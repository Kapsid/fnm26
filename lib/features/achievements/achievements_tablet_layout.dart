part of 'achievements_screen.dart';

/// The achievements on a tablet: the categories down the left with how many
/// of each are unlocked, the picked category's achievements beside them as a
/// grid of the phone's cards. The challenges are one button away in the
/// heading. The phone's one read, nothing more.
class _AchievementsTabletLayout extends ConsumerStatefulWidget {
  const _AchievementsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_AchievementsTabletLayout> createState() =>
      _AchievementsTabletLayoutState();
}

class _AchievementsTabletLayoutState
    extends ConsumerState<_AchievementsTabletLayout> {
  /// The category open on the right; the first one until the manager picks.
  AchievementCategory? _picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final viewAsync = ref.watch(achievementsViewProvider(careerId));
    return TabletPage(
      scaffoldKey: AchievementsScreen.tabletLayoutKey,
      title: l.sideAchievements,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      trailing: OutlinedButton.icon(
        onPressed: () => context.go('${Routes.challenges}?careerId=$careerId'),
        icon: const Icon(Icons.local_fire_department_rounded, size: 18),
        label: Text(l.careerChallenges),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.achievementsCouldNotLoad(e.toString()))),
        data: (views) {
          final grouped = _byCategory(views);
          final categories = [
            for (final c in AchievementCategory.values)
              if (grouped.containsKey(c)) c,
          ];
          if (categories.isEmpty) return const SizedBox.shrink();
          final picked = categories.contains(_picked)
              ? _picked!
              : categories.first;
          final earned = views.where((v) => v.earned).length;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 280,
                child: Panel(
                  title: l.achievementsUnlockedCount(earned, views.length),
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: ListView(
                    children: [
                      for (final c in categories)
                        TabletListRow(
                          key: ValueKey('achievements.category.${c.name}'),
                          label: achievementCategoryLabel(l, c),
                          trailing:
                              '${grouped[c]!.where((v) => v.earned).length}'
                              '/${grouped[c]!.length}',
                          selected: c == picked,
                          onTap: () => setState(() => _picked = c),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Panel(
                  title: achievementCategoryLabel(l, picked),
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    // A new category starts at its top.
                    key: ValueKey(picked),
                    padding: const EdgeInsets.all(12),
                    child: ColumnFlow(
                      minTileWidth: 300,
                      maxColumns: 2,
                      gap: AppSpacing.sm,
                      children: [
                        for (final v in grouped[picked]!)
                          _AchievementCard(view: v),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
