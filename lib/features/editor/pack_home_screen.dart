import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_language.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_ui.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'pack_home_tablet_layout.dart';

/// One database's home: whether it is ready to play, what is still missing
/// (each entry jumps to its place), and its sections, each with what it
/// holds and what it still needs.
class PackHomeScreen extends ConsumerStatefulWidget {
  const PackHomeScreen({required this.packId, super.key});

  static const Key tabletLayoutKey = Key('packHome.tabletLayout');
  static const Key undoKey = Key('packHome.undo');
  static const Key readyKey = Key('packHome.ready');
  static const Key notReadyKey = Key('packHome.notReady');

  /// The ready bar when a game update made the pack incompatible.
  static const Key attentionKey = Key('packHome.attention');
  static const Key showAllKey = Key('packHome.showAll');

  static Key issueKey(int index) => Key('packHome.issue.$index');

  /// Remove on the [index]th entry of the list, offered for an entry naming
  /// something the game no longer has, and for a nation's old rename.
  static Key removeKey(int index) => Key('packHome.remove.$index');

  /// "Remove all N like this" on the [index]th entry, offered when other
  /// entries share its kind (one unknown trait, deal or voice).
  static Key removeAllKey(int index) => Key('packHome.removeAll.$index');

  /// The note for values in [language], a language this build does not
  /// speak, and its Remove (all).
  static Key noteKey(String language) => Key('packHome.note.$language');
  static Key removeNoteKey(String language) =>
      Key('packHome.removeNote.$language');
  static Key sectionKey(EditorSection s) => Key('packHome.section.${s.name}');

  final int packId;

  @override
  ConsumerState<PackHomeScreen> createState() => _PackHomeScreenState();
}

class _PackHomeScreenState extends ConsumerState<PackHomeScreen> {
  /// How many of the missing things the phone lists before "Show all".
  static const int _preview = 5;

  /// The narrowest phone whose app bar centres the database's name.
  static const double _centredTitleWidth = 380;

  bool _showAll = false;

  int get _id => widget.packId;

  /// Back to the list, once the last edit is on the device: the list reads
  /// every pack again and must see it.
  Future<void> _back() async {
    await ref.read(packEditorProvider(_id).notifier).flush();
    if (mounted) context.go(Routes.editor);
  }

  /// Opens [section]; null is the database as a whole, whose home this
  /// already is, and [EditorSection.none] has no screen.
  void _open(EditorSection? section) {
    if (section == null || !section.hasScreen) return;
    context.go(editorSectionLocation(section, _id));
  }

  /// Opens where the [index]th entry is fixed (on its nation, when it has
  /// one): a pool's on that nation's Pool tab.
  void _openIssue(_PackView view, int index) {
    final issue = view.issues[index];
    final section = issue.section;
    if (section == null || !section.hasScreen) return;
    context.go(
      editorSectionLocation(
        section,
        _id,
        nationId: issue.nationId,
        pool: view.raw[index].where.startsWith('pools.'),
      ),
    );
  }

  /// Remove for the [index]th entry, when it names something the game no
  /// longer has or clashes with a name of the game's ([CompatIssue]), or is
  /// a nation's old rename that breaks a rule (no section edits nations
  /// now): deletes exactly that entry, as one undoable edit.
  VoidCallback? _remover(_PackView view, int index) {
    final issue = view.raw[index];
    final editor = ref.read(packEditorProvider(_id).notifier);
    if (issue is CompatIssue) {
      return () => unawaited(editor.removeUnknown(issue));
    }
    if (PackEditor.isNationIssue(issue)) {
      return () => editor.removeNationRename(issue);
    }
    return null;
  }

  /// "Remove all N like this" for the [index]th entry: the first of its
  /// kinds ([PackEditor.kindsOf]) other entries share, as one undoable
  /// edit; null when it is one of a kind.
  ({int count, VoidCallback onTap})? _removeAll(
    _PackView view,
    WorldPack pack,
    int index,
  ) {
    final editor = ref.read(packEditorProvider(_id).notifier);
    for (final kind in PackEditor.kindsOf(view.raw[index], pack)) {
      final count = PackEditor.countOfKind(pack, kind);
      if (count > 1) {
        return (count: count, onTap: () => editor.removeAllLike(kind));
      }
    }
    return null;
  }

  /// Removes every value in [language] (one undoable edit).
  void _removeLanguage(String language) => ref
      .read(packEditorProvider(_id).notifier)
      .removeAllLike('language:$language');

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(packEditorProvider(_id));
    final editor = ref.watch(packEditorProvider(_id).notifier);
    final tablet = useTabletLayout(context, ref);
    final pack = async.valueOrNull;

    if (pack == null) {
      final body = async.hasError
          ? AppErrorState(message: l.editorPackMissing)
          : const Center(child: CircularProgressIndicator());
      return tablet
          ? TabletPage(
              scaffoldKey: PackHomeScreen.tabletLayoutKey,
              title: l.editorTitle,
              onBack: () => context.go(Routes.editor),
              child: body,
            )
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => context.go(Routes.editor),
                ),
              ),
              body: body,
            );
    }

    final view = _PackView.of(
      l,
      pack,
      editor.world,
      editor.issues,
      editor.notes,
    );
    final undo = editor.canUndo
        ? () => ref.read(packEditorProvider(_id).notifier).undo()
        : null;

    if (tablet) {
      return _PackHomeTabletLayout(
        state: this,
        pack: pack,
        view: view,
        onUndo: undo,
      );
    }

    final shown = _showAll
        ? view.issues.length
        : view.issues.length.clamp(0, _preview);
    final centred = MediaQuery.sizeOf(context).width >= _centredTitleWidth;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: _back,
        ),
        title: Text(
          pack.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        // Centred, the name gets only twice its narrower side's room; on a
        // narrow phone, beside the language chip, that is a few letters.
        centerTitle: centred,
        titleSpacing: centred ? null : 0,
        actions: [
          const EditorLanguageChip(),
          IconButton(
            key: PackHomeScreen.undoKey,
            tooltip: l.editorUndo,
            icon: const Icon(Icons.undo),
            color: AppColors.primary,
            onPressed: undo,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.md,
                AppSpacing.marginMobile,
                0,
              ),
              sliver: SliverToBoxAdapter(child: _ReadyCard(view: view)),
            ),
            if (view.issues.isNotEmpty) ...[
              _header(context, l.editorMissingTitle),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                sliver: SliverList.builder(
                  itemCount: shown,
                  itemBuilder: (context, i) => _IssueRow(
                    index: i,
                    issue: view.issues[i],
                    onTap: () => _openIssue(view, i),
                    onRemove: _remover(view, i),
                    removeAll: _removeAll(view, pack, i),
                  ),
                ),
              ),
              if (view.issues.length > _preview)
                SliverToBoxAdapter(
                  child: Center(
                    child: TextButton(
                      key: PackHomeScreen.showAllKey,
                      onPressed: () => setState(() => _showAll = !_showAll),
                      child: Text(
                        _showAll
                            ? l.editorShowLess
                            : l.editorShowAll(view.issues.length),
                      ),
                    ),
                  ),
                ),
            ],
            if (view.notes.isNotEmpty) ...[
              _header(context, l.editorNotesTitle),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                sliver: SliverList.list(
                  children: [
                    for (final e in view.notes.entries)
                      _LanguageNote(
                        language: e.key,
                        count: e.value,
                        onRemove: () => _removeLanguage(e.key),
                      ),
                  ],
                ),
              ),
            ],
            _header(context, l.editorSectionsTitle),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                0,
                AppSpacing.marginMobile,
                AppSpacing.lg,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisExtent: _SectionTile.height,
                ),
                itemCount: EditorSection.onHome.length,
                itemBuilder: (context, i) {
                  final s = EditorSection.onHome[i];
                  return _SectionTile(
                    section: s,
                    facts: view.sections[s]!,
                    onTap: () => _open(s),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, String text) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.marginMobile,
      AppSpacing.lg,
      AppSpacing.marginMobile,
      AppSpacing.sm,
    ),
    sliver: SliverToBoxAdapter(child: _SectionHeader(text)),
  );
}

/// What one section holds and how many things in it need fixing.
typedef _SectionFacts = ({String count, int toFix});

/// Everything the home shows of a pack, worked out once per build.
class _PackView {
  const _PackView({
    required this.issues,
    required this.raw,
    required this.sections,
    required this.notes,
  });

  factory _PackView.of(
    AppLocalizations l,
    WorldPack pack,
    List<Nation> world,
    List<PackIssue> issues,
    List<UnknownLanguage> notes,
  ) {
    final byId = {for (final n in world) n.id: n};
    final described = [
      for (final i in issues) describePackIssue(l, i, pack, byId),
    ];
    final toFix = {for (final s in EditorSection.onHome) s: 0};
    for (final d in described) {
      if (d.section case final s? when s.hasScreen) toFix[s] = toFix[s]! + 1;
    }
    String count(EditorSection s) => switch (s) {
      EditorSection.players => l.editorCountPlayers(
        pack.squads.values.fold(0, (sum, squad) => sum + squad.length),
      ),
      EditorSection.clubs ||
      EditorSection.stadiums ||
      EditorSection.competitions ||
      EditorSection.yAccounts ||
      EditorSection.press ||
      EditorSection.nameLists ||
      EditorSection.managers ||
      EditorSection.sponsors => _nameCount(l, NameSection.of(s)!, pack),
      EditorSection.trophies => l.editorCountTrophies(pack.trophies.length),
      EditorSection.none => '',
    };
    final byLanguage = <String, int>{};
    for (final n in notes) {
      byLanguage.update(n.language, (c) => c + 1, ifAbsent: () => 1);
    }
    return _PackView(
      issues: described,
      raw: issues,
      notes: byLanguage,
      sections: {
        for (final s in EditorSection.onHome)
          s: (count: count(s), toFix: toFix[s]!),
      },
    );
  }

  final List<PackIssueText> issues;

  /// [issues] as [PackEditor.issues] gave them, index for index.
  final List<PackIssue> raw;
  final Map<EditorSection, _SectionFacts> sections;

  /// How many values the pack keeps in each language this build does not
  /// speak ([PackEditor.notes]). Never blocking: not part of [ready].
  final Map<String, int> notes;

  bool get ready => issues.isEmpty;

  /// Whether the pack refers to something the game no longer has, or adds
  /// a name the game's own already has.
  bool get attention => raw.any((i) => i is CompatIssue);

  int get readySections => sections.values.where((f) => f.toFix == 0).length;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.capsIn(Localizations.localeOf(context).languageCode),
    style: AppTypography.labelMedium.copyWith(
      color: AppColors.onSurfaceVariant,
    ),
  );
}

/// The "ready to play" bar: green when the pack can start a career, amber
/// with the count of things to fix when it cannot, and how many sections
/// are done.
class _ReadyCard extends StatelessWidget {
  const _ReadyCard({required this.view});

  final _PackView view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ready = view.ready;
    final attention = view.attention;
    final color = ready
        ? AppColors.positive
        : attention
        ? AppColors.error
        : AppColors.warning;
    final total = EditorSection.onHome.length;
    return AppCard(
      key: ready
          ? PackHomeScreen.readyKey
          : attention
          ? PackHomeScreen.attentionKey
          : PackHomeScreen.notReadyKey,
      color: color.withValues(alpha: 0.08),
      border: Border.all(color: color.withValues(alpha: 0.7)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                ready
                    ? Icons.check_circle
                    : attention
                    ? Icons.error_outline
                    : Icons.pending_outlined,
                color: color,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ready
                          ? l.editorReadyTitle
                          : attention
                          ? l.editorStatusAttention
                          : l.editorNotReadyTitle(view.issues.length),
                      style: AppTypography.titleMedium.copyWith(color: color),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      ready
                          ? l.editorReadyBody
                          : attention
                          ? l.editorAttentionBody
                          : l.editorNotReadyBody,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: LinearProgressIndicator(
              value: view.readySections / total,
              minHeight: 6,
              color: color,
              backgroundColor: AppColors.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            l.editorSectionsReady(view.readySections, total),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// One missing thing: where, what, and a chevron to go there.
class _IssueRow extends StatelessWidget {
  const _IssueRow({
    required this.index,
    required this.issue,
    required this.onTap,
    this.onRemove,
    this.removeAll,
  });

  final int index;
  final PackIssueText issue;
  final VoidCallback onTap;

  /// "Remove all N like this", when other entries share this one's kind.
  final ({int count, VoidCallback onTap})? removeAll;

  /// Deletes the entry, for one naming something the game no longer has;
  /// it then has nowhere to jump to that would fix it.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: AppCard(
      key: PackHomeScreen.issueKey(index),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Icon(
            switch (issue.section) {
              final s? => sectionIcon(s),
              null => Icons.info_outline,
            },
            size: 20,
            color: onRemove == null ? AppColors.warning : AppColors.error,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge,
                ),
                Text(
                  issue.detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                if (removeAll case (:final count, :final onTap))
                  _RemoveAllButton(
                    key: PackHomeScreen.removeAllKey(index),
                    count: count,
                    onPressed: onTap,
                  ),
              ],
            ),
          ),
          if (onRemove case final remove?)
            TextButton(
              key: PackHomeScreen.removeKey(index),
              onPressed: remove,
              child: Text(AppLocalizations.of(context).editorRemove),
            )
          else
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    ),
  );
}

/// "Remove all N like this": every entry of one kind, as one undoable edit.
class _RemoveAllButton extends StatelessWidget {
  const _RemoveAllButton({
    required this.count,
    required this.onPressed,
    super.key,
  });

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.error,
      ),
      child: Text(
        AppLocalizations.of(context).editorRemoveAllLike(count),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

/// The values a pack keeps in [language], one this build does not speak:
/// a note, not a problem. They block nothing; Remove drops them all.
class _LanguageNote extends StatelessWidget {
  const _LanguageNote({
    required this.language,
    required this.count,
    required this.onRemove,
  });

  final String language;
  final int count;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppCard(
        key: PackHomeScreen.noteKey(language),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.translate,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.editorUnknownLanguageNote(language, count),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      key: PackHomeScreen.removeNoteKey(language),
                      onPressed: onRemove,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        count > 1
                            ? l.editorRemoveAllLike(count)
                            : l.editorRemove,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A section: its icon and name, what it holds, and what it still needs.
class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.section,
    required this.facts,
    required this.onTap,
  });

  static const double height = 112;

  final EditorSection section;
  final _SectionFacts facts;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fix = facts.toFix > 0;
    return AppCard(
      key: PackHomeScreen.sectionKey(section),
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      border: fix
          ? Border.all(color: AppColors.warning.withValues(alpha: 0.7))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(sectionIcon(section), size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  sectionTitle(l, section),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: Text(
              sectionAbout(l, section),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            fix ? l.editorCountToFix(facts.toFix) : facts.count,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: fix ? AppColors.warning : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// A name section's count on the home: what it changes, and what it adds
/// (the added count alone when it changes nothing of the game's).
String _nameCount(AppLocalizations l, NameSection section, WorldPack pack) {
  final changed = changedCount(section, pack);
  final added = addedCount(section, pack);
  if (added == 0) return l.editorCountChanged(changed);
  if (changed == 0) return l.editorCountAdded(added);
  return '${l.editorCountChanged(changed)} · ${l.editorCountAdded(added)}';
}
