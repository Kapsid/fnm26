part of 'challenges_screen.dart';

/// One block of the challenges list: this save's own, or a tier of the
/// fixed ladder.
typedef _ChallengeSection = ({
  String id,
  String label,
  IconData icon,
  Color color,
  List<ChallengeView> views,
});

/// The phone's sections, in its order: this save's challenges first, then
/// the ladder bronze to legendary.
List<_ChallengeSection> _sections(
  AppLocalizations l,
  List<ChallengeView> views,
) {
  final procedural = views.where((v) => v.def.procedural).toList();
  final byTier = <ChallengeTier, List<ChallengeView>>{};
  for (final v in views.where((v) => !v.def.procedural)) {
    (byTier[v.def.tier] ??= []).add(v);
  }
  return [
    if (procedural.isNotEmpty)
      (
        id: 'save',
        label: l.achievementsThisSave,
        icon: Icons.auto_awesome_rounded,
        color: AppColors.primary,
        views: procedural,
      ),
    for (final tier in ChallengeTier.values)
      if (byTier[tier] case final list?)
        (
          id: tier.name,
          label: challengeTierLabel(l, tier),
          icon: Icons.workspace_premium_rounded,
          color: _tierColor(tier),
          views: list,
        ),
  ];
}

/// The challenges on a tablet: the tiers down the left with how many of each
/// are done, the picked tier's challenges beside them as a grid of the
/// phone's cards. The phone's one read, nothing more.
class _ChallengesTabletLayout extends ConsumerStatefulWidget {
  const _ChallengesTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_ChallengesTabletLayout> createState() =>
      _ChallengesTabletLayoutState();
}

class _ChallengesTabletLayoutState
    extends ConsumerState<_ChallengesTabletLayout> {
  /// The section open on the right, by id; the first until the manager picks.
  String? _picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final viewAsync = ref.watch(challengesViewProvider(careerId));
    return TabletPage(
      scaffoldKey: ChallengesScreen.tabletLayoutKey,
      title: l.careerChallenges,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.achievements}?careerId=$careerId'),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.achievementsCouldNotLoad(e.toString()))),
        data: (views) {
          final sections = _sections(l, views);
          if (sections.isEmpty) return const SizedBox.shrink();
          final picked = sections.firstWhere(
            (s) => s.id == _picked,
            orElse: () => sections.first,
          );
          final done = views.where((v) => v.complete).length;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 280,
                child: Panel(
                  title: l.achievementsConqueredCount(done, views.length),
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Text(
                          l.achievementsHardestTests,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      for (final s in sections)
                        TabletListRow(
                          key: ValueKey('challenges.section.${s.id}'),
                          leading: Icon(s.icon, size: 18, color: s.color),
                          label: s.label,
                          trailing:
                              '${s.views.where((v) => v.complete).length}'
                              '/${s.views.length}',
                          selected: s.id == picked.id,
                          onTap: () => setState(() => _picked = s.id),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Panel(
                  title: picked.label,
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    // A new section starts at its top.
                    key: ValueKey(picked.id),
                    padding: const EdgeInsets.all(12),
                    child: ColumnFlow(
                      minTileWidth: 300,
                      maxColumns: 2,
                      gap: AppSpacing.sm,
                      children: [
                        for (final v in picked.views) _ChallengeCard(view: v),
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
