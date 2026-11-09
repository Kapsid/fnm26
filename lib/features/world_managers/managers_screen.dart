import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/features/world_managers/manager_detail_screen.dart';
import 'package:fnm/features/world_managers/manager_row.dart';
import 'package:fnm/features/world_managers/managers_list_providers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'managers_tablet_layout.dart';

/// The world's national team managers: who is in charge of each nation now,
/// and the moves of the last two years.
class ManagersScreen extends StatelessWidget {
  const ManagersScreen({required this.careerId, super.key});

  final int careerId;

  static const Key tabletLayoutKey = Key('managers.tabletLayout');
  static const Key currentListKey = Key('managers.current');
  static const Key movesListKey = Key('managers.moves');
  static const Key currentTabKey = Key('managers.tab.current');
  static const Key movesTabKey = Key('managers.tab.moves');
  static const Key sortReputationKey = Key('managers.sort.reputation');
  static const Key sortNameKey = Key('managers.sort.name');
  static const Key rowKey = Key('managers.row');
  static const Key moveKey = Key('managers.move');

  /// Where back goes: the ranking this opens from.
  static void leave(BuildContext context, int careerId) => context.canPop()
      ? context.pop()
      : context.go('${Routes.ranking}?careerId=$careerId');

  @override
  Widget build(BuildContext context) {
    if (TabletShellScope.isActive(context)) {
      return _ManagersTabletLayout(careerId: careerId);
    }
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => leave(context, careerId),
        ),
        title: Text(
          l.mgrListTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ManagersBody(careerId: careerId),
    );
  }
}

enum _Sort { reputation, name }

/// The two tabs with their filter and sort, shared by the phone and tablet
/// layouts.
class ManagersBody extends ConsumerStatefulWidget {
  const ManagersBody({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<ManagersBody> createState() => _ManagersBodyState();
}

class _ManagersBodyState extends ConsumerState<ManagersBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  Confederation? _conf;
  _Sort _sort = _Sort.reputation;

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final nations = ref.watch(managerNationsProvider(careerId)).valueOrNull;
    return Column(
      children: [
        TabBar(
          controller: _tabs,
          tabs: [
            Tab(key: ManagersScreen.currentTabKey, text: l.mgrListCurrent),
            Tab(key: ManagersScreen.movesTabKey, text: l.mgrListRecentMoves),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              _current(context, l, nations ?? const {}),
              _moves(context, l, nations ?? const {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _current(
    BuildContext context,
    AppLocalizations l,
    Map<int, Nation> nations,
  ) {
    final async = ref.watch(managersListProvider(widget.careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.commonSomethingWentWrong)),
      data: (all) {
        if (all.isEmpty) return _empty(l.mgrListEmptyCurrent);
        final rows =
            [
              for (final r in all)
                if (_conf == null || r.conf == _conf) r,
            ]..sort(
              (a, b) => _sort == _Sort.name
                  ? a.m.name.compareTo(b.m.name)
                  : b.reputation != a.reputation
                  ? b.reputation.compareTo(a.reputation)
                  : a.m.name.compareTo(b.m.name),
            );
        return Column(
          children: [
            _controls(l),
            Expanded(
              child: ListView.builder(
                key: ManagersScreen.currentListKey,
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                itemCount: rows.length,
                itemBuilder: (context, i) =>
                    _currentRow(context, l, rows[i], nations),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _controls(AppLocalizations l) {
    Widget row(List<Widget> chips) => SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.marginMobile,
          vertical: AppSpacing.xs,
        ),
        children: chips,
      ),
    );
    return Column(
      children: [
        row([
          _chip(l.mgrListFilterAll, _conf == null, () {
            setState(() => _conf = null);
          }),
          for (final c in Confederation.values)
            _chip(
              confederationLabel(l, c),
              _conf == c,
              () => setState(() => _conf = c),
              key: Key('managers.conf.${c.name}'),
            ),
        ]),
        row([
          _chip(
            l.mgrListSortReputation,
            _sort == _Sort.reputation,
            () => setState(() => _sort = _Sort.reputation),
            key: ManagersScreen.sortReputationKey,
          ),
          _chip(
            l.mgrListSortName,
            _sort == _Sort.name,
            () => setState(() => _sort = _Sort.name),
            key: ManagersScreen.sortNameKey,
          ),
        ]),
      ],
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap, {Key? key}) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        key: key,
        label: Text(label),
        selected: active,
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _empty(String text) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ),
  );

  void _open(int managerId) => openWorldManager(
    context,
    careerId: widget.careerId,
    managerId: managerId,
  );

  Widget _currentRow(
    BuildContext context,
    AppLocalizations l,
    ManagerListRow r,
    Map<int, Nation> nations,
  ) {
    final nation = nations[r.nationId];
    final muted = AppTypography.bodyMedium.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return InkWell(
      key: ManagersScreen.rowKey,
      onTap: () => _open(r.m.managerId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            if (nation != null) FlagDisc(nation.code, size: 32),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.m.name, style: AppTypography.bodyLarge),
                  Text(
                    '${nation?.name ?? ''}, ${managerStyleText(l, r.m.style)}',
                    style: muted,
                  ),
                ],
              ),
            ),
            Text('${r.reputation}', style: AppTypography.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _moves(
    BuildContext context,
    AppLocalizations l,
    Map<int, Nation> nations,
  ) {
    final async = ref.watch(recentMovesProvider(widget.careerId));
    final namesAsync = ref.watch(recentMoveManagersProvider(widget.careerId));
    final names = namesAsync.valueOrNull;
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.commonSomethingWentWrong)),
      data: (moves) {
        if (moves.isEmpty) return _empty(l.mgrListEmptyMoves);
        if (namesAsync.hasError && names == null) {
          return Center(child: Text(l.commonSomethingWentWrong));
        }
        if (names == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          key: ManagersScreen.movesListKey,
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          itemCount: moves.length,
          itemBuilder: (context, i) =>
              _moveRow(context, l, moves[i], nations, names),
        );
      },
    );
  }

  Widget _moveRow(
    BuildContext context,
    AppLocalizations l,
    ManagerMove mv,
    Map<int, Nation> nations,
    Map<int, WorldManager> names,
  ) {
    final nation = nations[mv.nationId];
    final nationName = nation?.name ?? '';
    final out = names[mv.outgoingId];
    final inc = names[mv.incomingId];
    final lines = <String>[
      if (out != null)
        switch (mv.why) {
          SpellEnd.sacked => l.mgrNewsSacked(nationName, out.name),
          SpellEnd.resigned => l.mgrNewsResigned(nationName, out.name),
          SpellEnd.poached => l.mgrNewsPoached(nationName, out.name),
          SpellEnd.retired => l.mgrNewsRetired(nationName, out.name),
          SpellEnd.contractEnd => l.mgrNewsContractEnd(nationName, out.name),
          SpellEnd.replacedByPlayer => l.mgrNewsReplacedByPlayer(
            nationName,
            out.name,
          ),
          null => out.name,
        },
      if (inc != null) l.mgrNewsAppointed(nationName, inc.name),
    ];
    final target = (inc ?? out)?.managerId;
    return InkWell(
      key: ManagersScreen.moveKey,
      onTap: target == null ? null : () => _open(target),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            if (nation != null) FlagDisc(nation.code, size: 32),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in lines)
                    Text(line, style: AppTypography.bodyMedium),
                ],
              ),
            ),
            Text(
              AppDate.dayMonthYear(context, mv.date),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
