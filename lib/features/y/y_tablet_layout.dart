part of 'y_screen.dart';

/// An account's initial for its avatar: the first character of [name], or
/// nothing for an empty name (which must not throw).
String yInitial(String name) => name.characters.firstOrNull ?? '';

/// What the side column is showing instead of trending and voices.
sealed class _YSide {
  const _YSide();
}

final class _YSidePost extends _YSide {
  const _YSidePost(this.post);

  final YPost post;
}

final class _YSideAccount extends _YSide {
  const _YSideAccount(this.persona);

  final YPersona persona;
}

/// Y on a tablet: the timeline in the centre, and beside it what is being
/// talked about most and who is talking most. A post or an account opens in
/// that side column (its close button brings trending back), so the feed
/// never leaves the screen. The feed and its read mark are the phone State's.
class _YTabletLayout extends StatefulWidget {
  const _YTabletLayout({required this.feedAsync, required this.onBack});

  final AsyncValue<YTimeline> feedAsync;
  final VoidCallback onBack;

  @override
  State<_YTabletLayout> createState() => _YTabletLayoutState();
}

class _YTabletLayoutState extends State<_YTabletLayout> {
  _YSide? _side;

  static const double _sideWidth = 340;

  void _show(_YSide? side) => setState(() => _side = side);

  void _openPost(YPost p) => _show(_YSidePost(p));

  void _openAccount(YPost p) => _show(_YSideAccount(YFeed.personaOf(p)));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: YScreen.tabletLayoutKey,
      title: l.yTitle,
      onBack: widget.onBack,
      child: widget.feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (feed) {
          if (feed.posts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.yEmpty,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PanelBox(
                  child: YFeedList(
                    feed: feed,
                    onOpenPost: _openPost,
                    onOpenAccount: _openAccount,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(width: _sideWidth, child: _sideColumn(l, feed)),
            ],
          );
        },
      ),
    );
  }

  Widget _sideColumn(AppLocalizations l, YTimeline feed) {
    final all = feed.posts;
    return switch (_side) {
      null => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Panel(
              key: YScreen.trendingKey,
              title: l.yTrending,
              padding: EdgeInsets.zero,
              child: _TrendList(trends: yTrending(feed), onOpen: _openPost),
            ),
            const SizedBox(height: AppSpacing.md),
            Panel(
              key: YScreen.voicesKey,
              title: l.yVoices,
              padding: EdgeInsets.zero,
              child: _VoiceList(
                voices: yVoices(feed),
                onOpen: (persona) => _show(_YSideAccount(persona)),
              ),
            ),
          ],
        ),
      ),
      _YSidePost(:final post) => _SidePanel(
        key: YScreen.sideThreadKey,
        title: l.yConversation,
        onClose: () => _show(null),
        child: YPostThread(
          key: ValueKey(post.key),
          post: post,
          all: all,
          onAccountTap: _openAccount,
        ),
      ),
      _YSideAccount(:final persona) => _SidePanel(
        key: YScreen.sideProfileKey,
        title: persona.displayName,
        onClose: () => _show(null),
        child: YProfileView(
          key: ValueKey(persona.handle),
          persona: persona,
          all: all,
          onPostTap: _openPost,
        ),
      ),
    };
  }
}

/// A side-column panel with a close button in its header.
class _SidePanel extends StatelessWidget {
  const _SidePanel({
    required this.title,
    required this.onClose,
    required this.child,
    super.key,
  });

  final String title;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PanelBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 34,
            color: AppColors.surfaceContainer,
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.capsIn(Localizations.localeOf(context).languageCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TabletText.panelTitle,
                  ),
                ),
                IconButton(
                  key: YScreen.sideCloseKey,
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, color: AppColors.primary),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// The conversations with the most posts: who opened each, what they said,
/// and how many posts it has run to.
class _TrendList extends StatelessWidget {
  const _TrendList({required this.trends, required this.onOpen});

  final List<YTrend> trends;
  final void Function(YPost post) onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final t in trends)
          InkWell(
            onTap: () => onOpen(t.head),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.head.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.barStrong,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          yPostBody(l, t.head),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.cell,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 14,
                    color: AppColors.outline,
                  ),
                  const SizedBox(width: 4),
                  Text('${t.posts}', style: TabletText.cellNumeric),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The accounts that post most: who they are, what sort they are, and how
/// often they have spoken.
class _VoiceList extends StatelessWidget {
  const _VoiceList({required this.voices, required this.onOpen});

  final List<YVoiceCount> voices;
  final void Function(YPersona persona) onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final v in voices)
          InkWell(
            onTap: () => onOpen(v.persona),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.16),
                    ),
                    child: Text(
                      yInitial(v.persona.displayName),
                      style: TabletText.barStrong.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.persona.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.barStrong,
                        ),
                        Text(
                          v.persona.handle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.barMeta,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          yTraitLine(l, v.persona.trait),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.cell.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('${v.posts}', style: TabletText.cellNumeric),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
