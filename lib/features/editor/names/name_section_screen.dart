import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_language.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_ui.dart';
import 'package:fnm/features/editor/names/name_edit_form.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

export 'package:fnm/features/editor/names/name_edit_form.dart'
    show NameEditForm;
export 'package:fnm/features/editor/names/name_sections.dart' show NameSection;

part 'name_section_tablet_layout.dart';

/// A name section of a database (clubs, stadiums, competitions, Y accounts,
/// press, name lists, sponsors): every name the game uses there, with the
/// database's own beside it, a search, and an editor for the picked one (a
/// sheet on the phone, beside the list on a tablet).
///
/// Every section but the name lists follows the editor's language
/// ([editorLanguageProvider], picked from the [EditorLanguageChip] in the
/// top bar): under a language it shows and edits that language's names,
/// and under All languages the main ones.
///
/// Opened on [nationId] (a jump from the database home), the search starts
/// on that nation, and a per-nation section picks it.
class NameSectionScreen extends ConsumerStatefulWidget {
  const NameSectionScreen({
    required this.packId,
    required this.section,
    this.nationId,
    super.key,
  });

  static const Key tabletLayoutKey = Key('editorNames.tabletLayout');
  static const Key searchKey = Key('editorNames.search');
  static const Key undoKey = Key('editorNames.undo');

  static Key rowKey(String key) => Key('editorNames.row.$key');

  final int packId;
  final NameSection section;
  final int? nationId;

  @override
  ConsumerState<NameSectionScreen> createState() => _NameSectionScreenState();
}

/// The rows of a section worked out for one world, language and set of
/// game name lists.
typedef _Rows = ({
  List<Nation> world,
  Map<int, NameLists> lists,
  String locale,
  List<NameGroup> groups,
  Map<String, NameEntry> byKey,
});

class _NameSectionScreenState extends ConsumerState<NameSectionScreen> {
  final _search = TextEditingController();
  String _query = '';

  /// The row edited beside the list (tablet).
  String? _picked;

  /// Whether the jump to [NameSectionScreen.nationId] is done.
  bool _jumped = false;

  int get _id => widget.packId;
  NameSection get _section => widget.section;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _back() => context.go(editorPackLocation(_id));

  void _setQuery(String q) => setState(() => _query = q);

  _Rows? _rowsCache;

  /// Every row of the section: worked out once per world and language, not
  /// per keystroke of the search or per edit.
  _Rows _rows(
    AppLocalizations l,
    List<Nation> world,
    Map<int, NameLists> lists,
  ) {
    final c = _rowsCache;
    if (c != null &&
        identical(c.world, world) &&
        identical(c.lists, lists) &&
        c.locale == l.localeName) {
      return c;
    }
    final groups = nameGroups(_section, l, world, lists: lists);
    return _rowsCache = (
      world: world,
      lists: lists,
      locale: l.localeName,
      groups: groups,
      byKey: {
        for (final g in groups)
          for (final e in g.entries) e.key: e,
      },
    );
  }

  WorldPack? _issuesOf;
  Map<String, int> _issues = const {};

  /// How many things each row has to fix, once per pack state. The squads
  /// are left out: no name section shows them, and they are most of the
  /// work.
  Map<String, int> _toFix(WorldPack pack, List<Nation> world) {
    if (identical(pack, _issuesOf)) return _issues;
    final issues = PackRules.issues(
      pack.copyWith(squads: const {}),
      baseCodes: {for (final n in world) n.id: n.code},
    );
    _issuesOf = pack;
    return _issues = issuesByKey(_section, issues, pack: pack);
  }

  /// [groups] with only the rows the search finds (by the game's name, the
  /// database's name, the country and the like, and under a [language] the
  /// names shown in it).
  List<NameGroup> _filter(
    List<NameGroup> groups,
    WorldPack pack,
    String? language,
  ) {
    final q = searchFold(_query);
    if (q.isEmpty) return groups;
    bool hit(NameEntry e) {
      if (e.fold.contains(q)) return true;
      final o = nameOverride(_section, pack, e);
      if (o != null &&
          (searchFold(o.name).contains(q) ||
              searchFold(o.second).contains(q))) {
        return true;
      }
      if (language == null) return false;
      final v = valueIn(_section, pack, e, language);
      return searchFold(shownOf(v.name)).contains(q) ||
          (v.second != null && searchFold(shownOf(v.second!)).contains(q));
    }

    return [
      for (final g in groups)
        if (g.entries.where(hit).toList() case final entries
            when entries.isNotEmpty)
          (title: g.title, flagCode: g.flagCode, entries: entries),
    ];
  }

  /// Opened on a nation: search for it, and pick it where rows are nations.
  void _jump(List<Nation> world) {
    if (_jumped) return;
    _jumped = true;
    final id = widget.nationId;
    if (id == null) return;
    final nation = world.where((n) => n.id == id).firstOrNull;
    if (nation == null) return;
    _search.text = nation.name;
    _query = nation.name;
    if (_section == NameSection.nameLists) _picked = '$id';
  }

  void _open(
    NameEntry e, {
    required bool tablet,
    required List<Nation> world,
    required String? language,
  }) {
    if (tablet) {
      setState(() => _picked = e.key);
      return;
    }
    unawaited(
      showAdaptiveSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheet) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheet).bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.sm,
              AppSpacing.marginMobile,
              AppSpacing.lg,
            ),
            child: NameEditForm(
              packId: _id,
              section: _section,
              entry: e,
              world: world,
              language: language,
              onDone: () => Navigator.of(sheet).pop(),
            ),
          ),
        ),
      ),
    );
  }

  String _searchHint(AppLocalizations l) => switch (_section) {
    NameSection.clubs => l.editorNamesSearchClubs,
    NameSection.stadiums => l.editorNamesSearchStadiums,
    NameSection.nameLists => l.editorNamesSearchNations,
    _ => l.editorNamesSearch,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(packEditorProvider(_id));
    final editor = ref.watch(packEditorProvider(_id).notifier);
    final tablet = useTabletLayout(context, ref);
    final title = sectionTitle(l, _section.editorSection);
    final lists = _section == NameSection.nameLists
        ? ref.watch(editorNameListsProvider)
        : const AsyncValue<Map<int, NameLists>>.data({});
    // Name lists have no language: the chip is not shown there.
    final language = _section.perLanguage
        ? ref.watch(editorLanguageProvider)
        : null;
    final pack = async.valueOrNull;
    final listsValue = lists.hasError
        ? const <int, NameLists>{}
        : lists.valueOrNull;

    if (pack == null || listsValue == null) {
      return EditorFrame(
        tablet: tablet,
        tabletKey: NameSectionScreen.tabletLayoutKey,
        title: title,
        onBack: _back,
        body: async.hasError
            ? AppErrorState(message: l.editorPackMissing)
            : const Center(child: CircularProgressIndicator()),
      );
    }

    final world = editor.world;
    _jump(world);
    final rows = _rows(l, world, listsValue);
    final view = _NameView(
      pack: pack,
      groups: _filter(rows.groups, pack, language),
      toFix: _toFix(pack, world),
      language: language,
    );
    void undo() => editor.undo();
    final onUndo = editor.canUndo ? undo : null;

    if (tablet) {
      return _NameSectionTabletLayout(
        state: this,
        title: title,
        view: view,
        picked: _picked == null ? null : rows.byKey[_picked],
        world: world,
        onUndo: onUndo,
      );
    }
    return EditorFrame(
      tablet: false,
      tabletKey: NameSectionScreen.tabletLayoutKey,
      title: title,
      onBack: _back,
      actions: [
        if (_section.perLanguage) const EditorLanguageChip(),
        IconButton(
          key: NameSectionScreen.undoKey,
          tooltip: l.editorUndo,
          onPressed: onUndo,
          icon: const Icon(Icons.undo),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.sm,
              AppSpacing.marginMobile,
              AppSpacing.sm,
            ),
            child: _SearchField(state: this),
          ),
          Expanded(
            child: _NameList(
              state: this,
              view: view,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                0,
                AppSpacing.marginMobile,
                AppSpacing.lg,
              ),
              onTap: (e) =>
                  _open(e, tablet: false, world: world, language: language),
            ),
          ),
        ],
      ),
    );
  }
}

/// What the list shows for one pack state.
class _NameView {
  const _NameView({
    required this.pack,
    required this.groups,
    required this.toFix,
    required this.language,
  });

  final WorldPack pack;
  final List<NameGroup> groups;
  final Map<String, int> toFix;

  /// The editor's language, or null for All languages (and the name lists).
  final String? language;
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.state});

  final _NameSectionScreenState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextField(
      key: NameSectionScreen.searchKey,
      controller: state._search,
      onChanged: state._setQuery,
      textInputAction: TextInputAction.search,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: state._searchHint(l),
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

/// The rows, built only as they scroll into view; grouped ones under a
/// country heading that stays at the top while its rows go by.
class _NameList extends StatelessWidget {
  const _NameList({
    required this.state,
    required this.view,
    required this.padding,
    required this.onTap,
    this.picked,
    this.chevrons = true,
  });

  final _NameSectionScreenState state;
  final _NameView view;
  final EdgeInsets padding;
  final void Function(NameEntry) onTap;

  /// The row edited beside the list (tablet).
  final String? picked;

  /// Whether rows end in a chevron: they open a sheet (phone).
  final bool chevrons;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final section = state._section;
    Widget rows(List<NameEntry> entries) => SliverList.builder(
      itemCount: entries.length,
      itemBuilder: (context, i) => Padding(
        padding: EdgeInsets.fromLTRB(
          padding.left,
          0,
          padding.right,
          AppSpacing.xs,
        ),
        child: _NameTile(
          section: section,
          entry: entries[i],
          pack: view.pack,
          toFix: view.toFix[entries[i].key] ?? 0,
          language: view.language,
          picked: picked == entries[i].key,
          showChevron: chevrons,
          onTap: () => onTap(entries[i]),
        ),
      ),
    );

    // Said once, above the rows.
    final lang = view.language;
    final note = lang != null
        ? (Icons.translate, l.editorLanguageEditing(languageEndonym(lang)))
        : section.translated
        ? (Icons.translate, l.editorNamesEveryLanguage)
        : section == NameSection.stadiums
        ? (Icons.info_outline, l.editorNamesStadiumsNote)
        : null;
    return CustomScrollView(
      slivers: [
        if (note != null)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, 0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      note.$1,
                      size: 16,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        note.$2,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (view.groups.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EditorMessage(l.editorNamesNone, icon: Icons.search_off),
          ),
        // Padded inside, not by a SliverPadding: a pinned heading in a
        // padded group mislays itself.
        for (final g in view.groups)
          if (g.title == null)
            rows(g.entries)
          else
            SliverMainAxisGroup(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _GroupHeader(
                    title: g.title!,
                    flagCode: g.flagCode,
                    count: g.entries.length,
                    padding: EdgeInsets.only(
                      left: padding.left,
                      right: padding.right,
                    ),
                  ),
                ),
                rows(g.entries),
              ],
            ),
        SliverPadding(padding: EdgeInsets.only(bottom: padding.bottom)),
      ],
    );
  }
}

/// A country heading over its clubs or stadiums.
class _GroupHeader extends SliverPersistentHeaderDelegate {
  const _GroupHeader({
    required this.title,
    required this.flagCode,
    required this.count,
    required this.padding,
  });

  final String title;
  final String? flagCode;
  final int count;
  final EdgeInsets padding;

  static const double _height = 44;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    // The heading fills its whole extent, or the sliver's paint and layout
    // extents disagree.
    height: _height,
    color: AppColors.surface,
    padding: padding,
    child: Row(
      children: [
        if (flagCode case final code?) ...[
          FlagDisc(code, size: 24),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLarge,
          ),
        ),
        Text(
          '$count',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );

  @override
  bool shouldRebuild(_GroupHeader old) =>
      old.title != title ||
      old.flagCode != flagCode ||
      old.count != count ||
      old.padding != padding;
}

/// One row: the name as the database has it (in the editor's [language],
/// when one is picked), the game's name under it when they differ, and what
/// it still needs.
class _NameTile extends StatelessWidget {
  const _NameTile({
    required this.section,
    required this.entry,
    required this.pack,
    required this.toFix,
    required this.picked,
    required this.showChevron,
    required this.onTap,
    this.language,
  });

  final NameSection section;
  final NameEntry entry;
  final WorldPack pack;
  final int toFix;
  final bool picked;
  final bool showChevron;
  final VoidCallback onTap;
  final String? language;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final String name;
    final List<String> about;
    final bool changed;
    final lang = language;
    if (section == NameSection.nameLists) {
      final lists = NameEdits.listsOf(pack, entry);
      changed = pack.nameLists.containsKey(int.tryParse(entry.key));
      name = entry.original;
      about = [l.editorNamesListCounts(lists.first.length, lists.sur.length)];
    } else if (lang != null) {
      // In one language: its own name, else the main one (the same in every
      // language), else the game's there.
      final v = valueIn(section, pack, entry, lang);
      final second = v.second;
      changed = v.name.own != null || second?.own != null;
      name = shownOf(v.name);
      about = [
        if (name != v.name.game) l.editorNamesGameName(v.name.game),
        if (v.name.own == null && v.name.main != null) l.editorLanguageSame,
        ?entry.detail,
        if (second != null) shownOf(second),
      ];
    } else {
      final o = nameOverride(section, pack, entry);
      final languages = languagesOf(section, pack, entry);
      changed = o != null || languages.isNotEmpty;
      name = ActiveWorld.textOrNull(o?.name) ?? entry.original;
      final second = ActiveWorld.textOrNull(o?.second) ?? entry.original2;
      about = [
        if (name != entry.original) l.editorNamesGameName(entry.original),
        ?entry.detail,
        if (second.isNotEmpty) second,
        // The languages with a name of their own, by code.
        if (languages.isNotEmpty)
          languages.map((c) => c.toUpperCase()).join(', '),
      ];
    }
    final fix = toFix > 0;
    return AppCard(
      key: NameSectionScreen.rowKey(entry.key),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: picked ? AppColors.primary.withValues(alpha: 0.10) : null,
      border: fix
          ? Border.all(color: AppColors.warning.withValues(alpha: 0.6))
          : picked
          ? Border.all(color: AppColors.primary.withValues(alpha: 0.6))
          : null,
      child: Row(
        children: [
          if (!section.grouped && entry.flagCode != null) ...[
            FlagDisc(entry.flagCode!, size: 32),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge,
                ),
                if (about.isNotEmpty)
                  Text(
                    about.join(' · '),
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
            _FixMark(text: l.editorCountToFix(toFix))
          else if (changed)
            NameChangedMark(language: lang),
          if (showChevron)
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _FixMark extends StatelessWidget {
  const _FixMark({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.pending_outlined, size: 16, color: AppColors.warning),
      const SizedBox(width: AppSpacing.xs),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 110),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(color: AppColors.warning),
        ),
      ),
    ],
  );
}
