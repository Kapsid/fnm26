import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_ui.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'nation_list_tablet_layout.dart';

/// The players section of a database: every nation, with a search (by the
/// name the database gives it, the game's name or its code), confederation
/// filter chips and a mark saying whether its squad is ready. A nation opens
/// its squad.
class NationListScreen extends ConsumerStatefulWidget {
  const NationListScreen({required this.packId, super.key});

  static const Key tabletLayoutKey = Key('editorNations.tabletLayout');
  static const Key searchKey = Key('editorNations.search');

  static Key nationKey(int id) => Key('editorNations.nation.$id');
  static Key confKey(Confederation? c) =>
      Key('editorNations.conf.${c?.name ?? 'all'}');

  final int packId;

  @override
  ConsumerState<NationListScreen> createState() => _NationListScreenState();
}

/// One nation as the list shows it.
typedef _NationRow = ({
  Nation nation,
  String name,
  int players,
  int toFix,
  bool inPack,
});

class _NationListScreenState extends ConsumerState<NationListScreen> {
  final _search = TextEditingController();
  String _query = '';
  Confederation? _conf;

  int get _id => widget.packId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _back() => context.go(editorPackLocation(_id));

  void _setQuery(String q) => setState(() => _query = q);

  void _setConf(Confederation? c) => setState(() => _conf = c);

  void _open(int nationId) =>
      unawaited(context.push(editorSquadLocation(_id, nationId)));

  /// Every nation of [world] in [pack], by name, with what its squad needs.
  static List<_NationRow> _rows(
    WorldPack pack,
    List<Nation> world,
    List<PackIssue> issues,
  ) {
    final toFix = <int, int>{};
    for (final i in issues) {
      final parts = i.where.split('.');
      if (parts.first != 'squads' || parts.length < 2) continue;
      final id = int.tryParse(parts[1]);
      if (id != null) toFix[id] = (toFix[id] ?? 0) + 1;
    }
    final byId = {for (final n in world) n.id: n};
    return [
      for (final n in world)
        (
          nation: n,
          name: packNationName(pack, byId, n.id),
          players: pack.squads[n.id]?.length ?? 0,
          toFix: toFix[n.id] ?? 0,
          inPack: pack.squads.containsKey(n.id),
        ),
    ]..sort((a, b) => searchFold(a.name).compareTo(searchFold(b.name)));
  }

  List<_NationRow> _filter(WorldPack pack, List<_NationRow> rows) {
    final q = searchFold(_query);
    return [
      for (final r in rows)
        if ((_conf == null || r.nation.confederation == _conf) &&
            (q.isEmpty ||
                searchFold(r.name).contains(q) ||
                searchFold(r.nation.name).contains(q) ||
                searchFold(r.nation.englishName).contains(q) ||
                r.nation.code.toLowerCase().contains(q) ||
                (pack.nations[r.nation.id]?.code.toLowerCase().contains(q) ??
                    false)))
          r,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(packEditorProvider(_id));
    final editor = ref.watch(packEditorProvider(_id).notifier);
    final tablet = useTabletLayout(context, ref);
    final p = async.valueOrNull;
    final title = sectionTitle(l, EditorSection.players);

    if (p == null) {
      return EditorFrame(
        tablet: tablet,
        tabletKey: NationListScreen.tabletLayoutKey,
        title: title,
        onBack: _back,
        body: async.hasError
            ? AppErrorState(message: l.editorPackMissing)
            : const Center(child: CircularProgressIndicator()),
      );
    }

    final rows = _filter(p, _rows(p, editor.world, editor.issues));
    if (tablet) {
      return _NationListTabletLayout(state: this, title: title, rows: rows);
    }
    return EditorFrame(
      tablet: false,
      tabletKey: NationListScreen.tabletLayoutKey,
      title: title,
      onBack: _back,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.sm,
              AppSpacing.marginMobile,
              0,
            ),
            child: _SearchField(state: this),
          ),
          SizedBox(
            height: 48,
            child: _ConfChips(state: this, horizontal: true),
          ),
          Expanded(
            child: rows.isEmpty
                ? EditorMessage(l.editorNationsNone, icon: Icons.search_off)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.marginMobile,
                      0,
                      AppSpacing.marginMobile,
                      AppSpacing.lg,
                    ),
                    itemCount: rows.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: _NationTile(
                        row: rows[i],
                        onTap: () => _open(rows[i].nation.id),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.state});

  final _NationListScreenState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextField(
      key: NationListScreen.searchKey,
      controller: state._search,
      onChanged: state._setQuery,
      textInputAction: TextInputAction.search,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: l.editorNationsSearch,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: state._query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                onPressed: () {
                  state._search.clear();
                  state._setQuery('');
                },
              ),
      ),
    );
  }
}

/// "All" and one chip per confederation.
class _ConfChips extends StatelessWidget {
  const _ConfChips({required this.state, required this.horizontal});

  final _NationListScreenState state;

  /// One scrolling row (the phone) rather than a wrap (the tablet).
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final chips = [
      for (final c in <Confederation?>[null, ...Confederation.values])
        ChoiceChip(
          key: NationListScreen.confKey(c),
          label: Text(c == null ? l.editorFilterAll : confederationLabel(l, c)),
          selected: state._conf == c,
          onSelected: (_) => state._setConf(c),
        ),
    ];
    if (!horizontal) {
      return Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: chips,
      );
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.xs,
      ),
      itemCount: chips.length,
      separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
      itemBuilder: (_, i) => chips[i],
    );
  }
}

/// A nation: flag, name, confederation and squad size, and whether its
/// squad is ready.
class _NationTile extends StatelessWidget {
  const _NationTile({required this.row, required this.onTap});

  final _NationRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fix = row.toFix > 0;
    return AppCard(
      key: NationListScreen.nationKey(row.nation.id),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: fix
          ? Border.all(color: AppColors.warning.withValues(alpha: 0.6))
          : null,
      child: Row(
        children: [
          FlagDisc(row.nation.code, size: 36),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge,
                ),
                Text(
                  '${confederationLabel(l, row.nation.confederation)} · '
                  '${l.editorCountPlayers(row.players)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (fix)
            _Mark(
              icon: Icons.pending_outlined,
              color: AppColors.warning,
              text: l.editorCountToFix(row.toFix),
            )
          else if (row.inPack)
            _Mark(
              icon: Icons.check_circle,
              color: AppColors.positive,
              text: l.editorNationSquadReady,
            ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _Mark extends StatelessWidget {
  const _Mark({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: AppSpacing.xs),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 110),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(color: color),
        ),
      ),
    ],
  );
}
