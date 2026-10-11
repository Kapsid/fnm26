part of 'manager_screen.dart';

/// The manager's page on a tablet: his skills (where the points go) on the
/// left, his name and his staff on the right, each column scrolling on its
/// own. The phone's cards, side by side: a `DashboardGrid` cannot hold the
/// staff card, whose names size themselves with a LayoutBuilder.
class _ManagerTabletLayout extends ConsumerWidget {
  const _ManagerTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(managerViewProvider(careerId));
    return TabletPage(
      scaffoldKey: ManagerScreen.tabletLayoutKey,
      title: l.sideManager,
      // Back to whatever opened this (the hub's skills prompt pushes it), or
      // to the hub when the sidebar did.
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (view) => view == null
            ? const SizedBox.shrink()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      child: KeyedSubtree(
                        key: ManagerScreen.skillsKey,
                        child: _SkillsCard(careerId: careerId, view: view),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _NameCard(
                            careerId: careerId,
                            name: view.career.managerName,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Read-only: hiring is on the budget screen, where
                          // the wages are weighed against the departments.
                          StaffCard(careerId: careerId, readOnly: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
