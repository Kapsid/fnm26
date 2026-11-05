import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';
import 'package:fnm/features/editor/players/player_edit_screen.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'squad_tablet_layout.dart';

/// One nation's squad in a database: what it still needs, then its players
/// by position. Add a player (the position the squad lacks most), swipe one
/// away (Undo on the snackbar), tap one to edit him.
class SquadScreen extends ConsumerStatefulWidget {
  const SquadScreen({required this.packId, required this.nationId, super.key});

  static const Key tabletLayoutKey = Key('editorSquad.tabletLayout');
  static const Key addKey = Key('editorSquad.add');
  static const Key undoKey = Key('editorSquad.undo');
  static const Key summaryKey = Key('editorSquad.summary');

  static Key playerKey(int id) => Key('editorSquad.player.$id');
  static Key duplicateKey(int id) => Key('editorSquad.duplicate.$id');

  final int packId;
  final int nationId;

  @override
  ConsumerState<SquadScreen> createState() => _SquadScreenState();
}

/// One line of the squad list: a position group's heading or a player.
typedef _Line = ({PositionCategory? heading, PackPlayer? player});

class _SquadScreenState extends ConsumerState<SquadScreen> {
  /// The player edited beside the list (tablet).
  int? _picked;

  int get _id => widget.packId;
  int get _nation => widget.nationId;

  PackEditor get _editor => ref.read(packEditorProvider(_id).notifier);

  void _back() => editorBack(context, '${Routes.editorPlayers}?id=$_id');

  void _open(int playerId, {required bool tablet}) {
    if (tablet) {
      setState(() => _picked = playerId);
    } else {
      unawaited(context.push(editorPlayerLocation(_id, _nation, playerId)));
    }
  }

  void _unpick() => setState(() => _picked = null);

  void _add({required bool tablet}) {
    final l = AppLocalizations.of(context);
    PackPlayer? added;
    _editor.update((p) {
      final r = SquadEdits.add(p, _nation);
      if (r == null) return p;
      added = r.player;
      return r.pack;
    });
    final player = added;
    if (player == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l.editorSquadFull(PackRules.squadMax))),
        );
      return;
    }
    _open(player.id, tablet: tablet);
  }

  void _remove(PackPlayer player) {
    final l = AppLocalizations.of(context);
    _editor.update((p) => SquadEdits.remove(p, _nation, player.id));
    if (_picked == player.id) setState(() => _picked = null);
    showRemovedSnackBar(context, l, player, _editor);
  }

  static List<_Line> _lines(List<PackPlayer> squad) {
    final out = <_Line>[];
    PositionCategory? group;
    for (final p in SquadEdits.sorted(squad)) {
      if (p.position.category != group) {
        group = p.position.category;
        out.add((heading: group, player: null));
      }
      out.add((heading: null, player: p));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(packEditorProvider(_id));
    final editor = ref.watch(packEditorProvider(_id).notifier);
    final tablet = useTabletLayout(context, ref);
    final pack = async.valueOrNull;
    final known = editor.world.any((n) => n.id == _nation);

    if (pack == null || !known) {
      return EditorFrame(
        tablet: tablet,
        tabletKey: SquadScreen.tabletLayoutKey,
        title: l.editorSectionPlayers,
        onBack: _back,
        body: async.hasError
            ? AppErrorState(message: l.editorPackMissing)
            : pack == null
            ? const Center(child: CircularProgressIndicator())
            : EditorMessage(l.editorNationGone),
      );
    }

    final world = {for (final n in editor.world) n.id: n};
    final title = packNationName(pack, world, _nation);
    final squad = pack.squads[_nation] ?? const <PackPlayer>[];
    final issues = [
      for (final i in editor.squadIssues(_nation))
        describePackIssue(l, i, pack, world).detail,
    ];
    final view = (
      pack: pack,
      squad: squad,
      lines: _lines(squad),
      issues: issues,
      duplicates: SquadEdits.duplicateNames(squad),
    );
    final undo = editor.canUndo ? editor.undo : null;

    if (tablet) {
      return _SquadTabletLayout(
        state: this,
        title: title,
        view: view,
        onUndo: undo,
      );
    }
    return EditorFrame(
      tablet: false,
      tabletKey: SquadScreen.tabletLayoutKey,
      title: title,
      onBack: _back,
      actions: [
        IconButton(
          key: SquadScreen.undoKey,
          tooltip: l.editorUndo,
          icon: const Icon(Icons.undo),
          color: AppColors.primary,
          onPressed: undo,
        ),
      ],
      fab: FloatingActionButton.extended(
        key: SquadScreen.addKey,
        onPressed: () => _add(tablet: false),
        icon: const Icon(Icons.person_add_alt_1),
        label: Text(l.editorSquadAdd),
      ),
      body: _SquadList(
        view: view,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.md,
          AppSpacing.marginMobile,
          96,
        ),
        onTap: (p) => _open(p.id, tablet: false),
        onRemove: _remove,
      ),
    );
  }
}

/// Says [player] left the squad, with Undo. Call it right after the
/// removal: the Undo undoes that removal only, and the snackbar goes as soon
/// as anything else is edited.
void showRemovedSnackBar(
  BuildContext context,
  AppLocalizations l,
  PackPlayer player,
  PackEditor editor,
) {
  final removal = editor.revision;
  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  final bar = messenger.showSnackBar(
    SnackBar(
      content: Text(l.editorSquadRemoved(playerLabel(l, player))),
      action: SnackBarAction(
        label: l.editorUndo,
        onPressed: () => editor.undoIfLatest(removal),
      ),
    ),
  );
  var open = true;
  late final void Function() stop;
  stop = editor.addListener((_) {
    if (open && editor.revision != removal) {
      open = false;
      bar.close();
    }
  }, fireImmediately: false);
  unawaited(
    bar.closed.then((_) {
      open = false;
      if (editor.mounted) stop();
    }),
  );
}

typedef _SquadView = ({
  WorldPack pack,
  List<PackPlayer> squad,
  List<_Line> lines,
  List<String> issues,
  Set<String> duplicates,
});

/// The summary, then the players by position group: built as it scrolls.
class _SquadList extends StatelessWidget {
  const _SquadList({
    required this.view,
    required this.padding,
    required this.onTap,
    required this.onRemove,
    this.picked,
  });

  final _SquadView view;
  final EdgeInsets padding;
  final void Function(PackPlayer) onTap;
  final void Function(PackPlayer) onRemove;
  final int? picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lines = view.lines;
    return ListView.builder(
      padding: padding,
      itemCount: lines.length + 1 + (lines.isEmpty ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == 0) return _Summary(view: view);
        if (lines.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            child: EditorMessage(
              l.editorSquadEmpty,
              icon: Icons.person_add_alt_1,
            ),
          );
        }
        final line = lines[i - 1];
        final heading = line.heading;
        if (heading != null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.md,
              0,
              AppSpacing.xs,
            ),
            child: Text(
              categoryTitle(l, heading),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          );
        }
        final p = line.player!;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Dismissible(
            key: ValueKey('squad-${p.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.85),
                borderRadius: AppRadii.mdAll,
              ),
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (_) => onRemove(p),
            child: _PlayerRow(
              pack: view.pack,
              player: p,
              duplicate: view.duplicates.contains(SquadEdits.nameKey(p.name)),
              picked: picked == p.id,
              onTap: () => onTap(p),
            ),
          ),
        );
      },
    );
  }
}

/// How many players and of which kind the squad has against what it needs,
/// and what is still missing (or that it is ready).
class _Summary extends StatelessWidget {
  const _Summary({required this.view});

  final _SquadView view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final counts = SquadEdits.counts(view.squad);
    final ready = view.issues.isEmpty;
    final color = ready ? AppColors.positive : AppColors.warning;
    final size = view.squad.length;
    final sizeOk = size >= PackRules.squadMin && size <= PackRules.squadMax;
    return AppCard(
      key: SquadScreen.summaryKey,
      color: color.withValues(alpha: 0.06),
      border: Border.all(color: color.withValues(alpha: 0.6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.editorCountPlayers(size),
                  style: AppTypography.titleMedium.copyWith(
                    color: sizeOk ? AppColors.onSurface : AppColors.warning,
                  ),
                ),
              ),
              Text(
                '${PackRules.squadMin}-${PackRules.squadMax}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final c in PositionCategory.values) ...[
                if (c != PositionCategory.goalkeeper)
                  const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _GroupCount(
                    label: categoryShort(l, c),
                    have: counts[c]!,
                    need: SquadEdits.minimums[c]!,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (ready)
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: color),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l.editorSquadReady,
                    style: AppTypography.bodySmall.copyWith(color: color),
                  ),
                ),
              ],
            )
          else
            for (final issue in view.issues.take(6))
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.pending_outlined, size: 16, color: color),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        issue,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          if (view.issues.length > 6)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 20),
              child: Text(
                l.editorCountToFix(view.issues.length - 6),
                style: AppTypography.labelSmall.copyWith(color: color),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.editorSquadRules(
              PackRules.squadMin,
              PackRules.squadMax,
              PackRules.gkMin,
              PackRules.defMin,
              PackRules.midMin,
              PackRules.fwdMin,
            ),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// "GK 3/3": a position group's count against its minimum.
class _GroupCount extends StatelessWidget {
  const _GroupCount({
    required this.label,
    required this.have,
    required this.need,
  });

  final String label;
  final int have;
  final int need;

  @override
  Widget build(BuildContext context) {
    final short = have < need;
    final color = short ? AppColors.warning : AppColors.positive;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.smAll,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            '$have/$need',
            style: AppTypography.labelLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// A player: position, name (with a badge when another shares it), age and
/// club, overall and potential.
class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.pack,
    required this.player,
    required this.duplicate,
    required this.picked,
    required this.onTap,
  });

  final WorldPack pack;
  final PackPlayer player;
  final bool duplicate;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = player;
    final unnamed = p.name.trim().isEmpty;
    final overall = SquadEdits.overallOf(p);
    return AppCard(
      key: SquadScreen.playerKey(p.id),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.sm,
      ),
      color: picked ? AppColors.primary.withValues(alpha: 0.10) : null,
      border: picked
          ? Border.all(color: AppColors.primary.withValues(alpha: 0.7))
          : unnamed
          ? Border.all(color: AppColors.warning.withValues(alpha: 0.6))
          : null,
      child: Row(
        children: [
          PositionBadge(p.position),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        playerLabel(l, p),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelLarge.copyWith(
                          color: unnamed ? AppColors.warning : null,
                          fontStyle: unnamed ? FontStyle.italic : null,
                        ),
                      ),
                    ),
                    if (duplicate) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Tooltip(
                        message: l.editorSquadDuplicate,
                        child: Icon(
                          Icons.warning_amber_rounded,
                          key: SquadScreen.duplicateKey(p.id),
                          size: 16,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${l.editorPlayerAgeShort(p.age)} · '
                  '${clubLabel(l, pack, p)}',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$overall',
                style: AppTypography.titleMedium.copyWith(
                  color: overallColor(overall),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    size: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${p.potential}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
