import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/editor/players/squad_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

part 'player_edit_tablet_layout.dart';

/// One player of a database: his name, age, position and club, his overall
/// with a player type, and his potential. Every change is saved as it is
/// made.
class PlayerEditScreen extends ConsumerWidget {
  const PlayerEditScreen({
    required this.packId,
    required this.nationId,
    required this.playerId,
    super.key,
  });

  static const Key tabletLayoutKey = Key('editorPlayer.tabletLayout');
  static const Key undoKey = Key('editorPlayer.undo');

  final int packId;
  final int nationId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(packEditorProvider(packId));
    final editor = ref.watch(packEditorProvider(packId).notifier);
    final tablet = useTabletLayout(context, ref);
    final pack = async.valueOrNull;
    final player = pack?.squads[nationId]
        ?.where((p) => p.id == playerId)
        .firstOrNull;
    void back() => editorBack(context, editorSquadLocation(packId, nationId));

    final title = player == null
        ? l.editorSectionPlayers
        : playerLabel(l, player);
    final undo = editor.canUndo ? editor.undo : null;
    final form = PlayerEditForm(
      packId: packId,
      nationId: nationId,
      playerId: playerId,
      onRemoved: (p) {
        showRemovedSnackBar(context, l, p, editor);
        back();
      },
    );
    final body = pack == null
        ? (async.hasError
              ? AppErrorState(message: l.editorPackMissing)
              : const Center(child: CircularProgressIndicator()))
        : player == null
        ? EditorMessage(l.editorPlayerGone)
        : tablet
        ? _PlayerEditTabletBody(form: form)
        : ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.md,
              AppSpacing.marginMobile,
              AppSpacing.xl,
            ),
            children: [form],
          );

    return EditorFrame(
      tablet: tablet,
      tabletKey: tabletLayoutKey,
      title: title,
      onBack: back,
      actions: [
        if (tablet)
          TextButton.icon(
            key: undoKey,
            onPressed: undo,
            icon: const Icon(Icons.undo),
            label: Text(l.editorUndo),
          )
        else
          IconButton(
            key: undoKey,
            tooltip: l.editorUndo,
            icon: const Icon(Icons.undo),
            color: AppColors.primary,
            onPressed: undo,
          ),
      ],
      body: body,
    );
  }
}

/// The fields of one player, used by the player page and beside the squad
/// on a tablet. Two columns when it has the room (who he is; how good he
/// is), one otherwise.
class PlayerEditForm extends ConsumerStatefulWidget {
  const PlayerEditForm({
    required this.packId,
    required this.nationId,
    required this.playerId,
    this.onRemoved,
    super.key,
  });

  static const Key nameKey = Key('editorPlayer.name');
  static const Key ageLessKey = Key('editorPlayer.age.less');
  static const Key ageMoreKey = Key('editorPlayer.age.more');
  static const Key ageKey = Key('editorPlayer.age');
  static const Key clubKey = Key('editorPlayer.club');
  static const Key overallKey = Key('editorPlayer.overall');
  static const Key overallNumberKey = Key('editorPlayer.overall.number');
  static const Key overallLessKey = Key('editorPlayer.overall.less');
  static const Key overallMoreKey = Key('editorPlayer.overall.more');
  static const Key potentialKey = Key('editorPlayer.potential');
  static const Key removeKey = Key('editorPlayer.remove');
  static const Key clubSearchKey = Key('editorPlayer.club.search');

  static Key positionKey(PlayerPosition p) => Key('editorPlayer.pos.${p.name}');
  static Key typeKey(PlayerType t) => Key('editorPlayer.type.${t.name}');
  static Key clubOptionKey(String? club) =>
      Key('editorPlayer.club.option.${club ?? '-'}');

  /// The width from which the form takes two columns.
  static const double twoColumnWidth = 720;

  final int packId;
  final int nationId;
  final int playerId;

  /// Called with the player once "Remove from squad" took him out.
  final void Function(PackPlayer removed)? onRemoved;

  @override
  ConsumerState<PlayerEditForm> createState() => _PlayerEditFormState();
}

class _PlayerEditFormState extends ConsumerState<PlayerEditForm> {
  final _name = TextEditingController();
  final _nameFocus = FocusNode();

  /// The type the chips show: the one last picked here, else the one the
  /// stored attributes were made with ([PlayerBuild.typeOf]).
  PlayerType? _type;

  /// The attributes this form last wrote: anything else (an undo) resets
  /// [_type] from what is stored.
  Object? _wrote;

  /// One spell of typing, one slider drag: each is one undo step.
  Object? _nameRun;
  Object? _overallRun;
  Object? _potentialRun;

  PackEditor get _editor =>
      ref.read(packEditorProvider(widget.packId).notifier);

  PackPlayer? _of(WorldPack? pack) => pack?.squads[widget.nationId]
      ?.where((p) => p.id == widget.playerId)
      .firstOrNull;

  @override
  void initState() {
    super.initState();
    final p = _of(ref.read(packEditorProvider(widget.packId)).valueOrNull);
    if (p != null) {
      _name.text = p.name;
      _type = PlayerBuild.typeOf(p.position, p.attributes);
      _wrote = p.attributes;
    }
    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus || !mounted) return;
      // Done typing: the name keeps no stray spaces at either end.
      final run = _nameRun;
      _nameRun = null;
      _edit((p) => SquadEdits.copy(p, name: p.name.trim()), group: run);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  /// Applies [change] to the player as the pack holds him now.
  void _edit(PackPlayer Function(PackPlayer) change, {Object? group}) {
    _editor.update((pack) {
      final p = _of(pack);
      if (p == null) return pack;
      final next = change(p);
      if (next == p) return pack;
      _wrote = next.attributes;
      return SquadEdits.replace(pack, widget.nationId, next);
    }, group: group);
  }

  void _rate(int overall, PlayerType type, {Object? group}) {
    _type = type;
    _edit((p) => SquadEdits.rated(p, overall, type), group: group);
  }

  void _remove(PackPlayer p) {
    _editor.update((pack) => SquadEdits.remove(pack, widget.nationId, p.id));
    widget.onRemoved?.call(p);
  }

  Future<void> _pickClub(WorldPack pack, PackPlayer p) async {
    final world = ref.read(packEditorProvider(widget.packId).notifier).world;
    final code =
        world.where((n) => n.id == widget.nationId).firstOrNull?.code ?? '';
    final picked = await showAdaptiveSheet<_ClubOption>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => _ClubPicker(
        options: _clubOptions(AppLocalizations.of(context), pack, p, code),
        current: p.club,
      ),
    );
    if (picked == null || !mounted) return;
    _edit((p) => SquadEdits.withClub(p, picked.club, picked.country));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    ref.listen(packEditorProvider(widget.packId), (_, next) {
      final p = _of(next.valueOrNull);
      if (p == null) return;
      if (p.name != _name.text) {
        _name.value = TextEditingValue(
          text: p.name,
          selection: TextSelection.collapsed(offset: p.name.length),
        );
      }
      if (p.attributes != _wrote) {
        setState(() {
          _type = PlayerBuild.typeOf(p.position, p.attributes);
          _wrote = p.attributes;
        });
      }
    });
    final pack = ref.watch(packEditorProvider(widget.packId)).valueOrNull;
    final p = _of(pack);
    if (pack == null || p == null) return EditorMessage(l.editorPlayerGone);
    final type = _type ??= PlayerBuild.typeOf(p.position, p.attributes);
    final overall = SquadEdits.overallOf(p);
    final squad = pack.squads[widget.nationId] ?? const <PackPlayer>[];
    final duplicate =
        p.name.trim().isNotEmpty &&
        SquadEdits.duplicateNames(squad).contains(SquadEdits.nameKey(p.name));

    final who = [
      _nameField(l, p, duplicate),
      const SizedBox(height: AppSpacing.lg),
      _ageStepper(l, p),
      const SizedBox(height: AppSpacing.lg),
      _positions(l, p, type),
      const SizedBox(height: AppSpacing.lg),
      _clubField(l, pack, p),
    ];
    final howGood = [
      _overall(l, p, overall, type),
      const SizedBox(height: AppSpacing.lg),
      _types(l, overall, type),
      const SizedBox(height: AppSpacing.md),
      _qualities(l, p),
      const SizedBox(height: AppSpacing.lg),
      _potential(l, p, overall),
    ];
    final remove = Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        key: PlayerEditForm.removeKey,
        onPressed: () => _remove(p),
        style: TextButton.styleFrom(foregroundColor: AppColors.error),
        icon: const Icon(Icons.person_remove_outlined),
        label: Text(l.editorPlayerRemove),
      ),
    );

    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= PlayerEditForm.twoColumnWidth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _card(who)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _card(howGood)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              remove,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(who),
            const SizedBox(height: AppSpacing.md),
            _card(howGood),
            const SizedBox(height: AppSpacing.sm),
            remove,
          ],
        );
      },
    );
  }

  Widget _card(List<Widget> children) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs + 2),
    child: Text(
      text.capsIn(Localizations.localeOf(context).languageCode),
      style: AppTypography.labelMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
  );

  Widget _nameField(AppLocalizations l, PackPlayer p, bool duplicate) {
    final problem = PackRules.checkName(p.name);
    final error = switch (problem) {
      null => null,
      FieldReason.empty => l.editorPlayerNameNeeded,
      FieldReason.tooLong => l.editorIssueNameTooLong(p.name.trim()),
      _ => l.editorPlayerNameBad,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label(l.editorPlayerName),
        TextField(
          key: PlayerEditForm.nameKey,
          controller: _name,
          focusNode: _nameFocus,
          maxLength: PackRules.nameMax,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.onSurface),
          onChanged: (v) {
            final run = _nameRun ??= Object();
            _edit((p) => SquadEdits.copy(p, name: v), group: run);
          },
          onSubmitted: (_) => _nameFocus.unfocus(),
          decoration: InputDecoration(
            hintText: l.editorPlayerNameHint,
            errorText: error,
            helper: duplicate && error == null
                ? Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          l.editorSquadDuplicate,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _ageStepper(AppLocalizations l, PackPlayer p) => Row(
    children: [
      Expanded(child: _label(l.editorPlayerAge)),
      _Stepper(
        valueKey: PlayerEditForm.ageKey,
        lessKey: PlayerEditForm.ageLessKey,
        moreKey: PlayerEditForm.ageMoreKey,
        value: p.age,
        onLess: p.age > PackRules.ageMin
            ? () => _edit((p) => SquadEdits.copy(p, age: p.age - 1))
            : null,
        onMore: p.age < PackRules.ageMax
            ? () => _edit((p) => SquadEdits.copy(p, age: p.age + 1))
            : null,
      ),
    ],
  );

  Widget _positions(AppLocalizations l, PackPlayer p, PlayerType type) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _label(l.editorPlayerPosition),
          for (final c in PositionCategory.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final pos in PlayerPosition.values)
                    if (pos.category == c)
                      ChoiceChip(
                        key: PlayerEditForm.positionKey(pos),
                        label: Text(pos.label),
                        tooltip: positionName(l, pos),
                        selected: p.position == pos,
                        onSelected: (_) => _edit(
                          (p) => SquadEdits.moved(p, pos, _type ?? type),
                        ),
                      ),
                ],
              ),
            ),
          Text(
            positionName(l, p.position),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      );

  Widget _clubField(AppLocalizations l, WorldPack pack, PackPlayer p) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _label(l.editorPlayerClub),
      Material(
        color: AppColors.surfaceContainerHighest,
        borderRadius: AppRadii.mdAll,
        child: InkWell(
          key: PlayerEditForm.clubKey,
          borderRadius: AppRadii.mdAll,
          onTap: () => _pickClub(pack, p),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 4,
            ),
            child: Row(
              children: [
                if ((p.clubCountry ?? '').isNotEmpty) ...[
                  FlagDisc(p.clubCountry!, size: 22),
                  const SizedBox(width: AppSpacing.sm),
                ] else ...[
                  const Icon(
                    Icons.shield_outlined,
                    size: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    clubLabel(l, pack, p),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyLarge,
                  ),
                ),
                const Icon(
                  Icons.search,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _overall(
    AppLocalizations l,
    PackPlayer p,
    int overall,
    PlayerType type,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _label(l.editorPlayerOverall),
      Row(
        children: [
          IconButton.filledTonal(
            key: PlayerEditForm.overallLessKey,
            tooltip: l.editorPlayerLess,
            onPressed: overall > 1 ? () => _rate(overall - 1, type) : null,
            icon: const Icon(Icons.remove),
          ),
          Expanded(
            child: Center(
              child: Container(
                key: PlayerEditForm.overallNumberKey,
                width: 96,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: overallColor(overall).withValues(alpha: 0.12),
                  borderRadius: AppRadii.lgAll,
                  border: Border.all(
                    color: overallColor(overall).withValues(alpha: 0.6),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$overall',
                  style: AppTypography.headlineLarge.copyWith(
                    color: overallColor(overall),
                  ),
                ),
              ),
            ),
          ),
          IconButton.filledTonal(
            key: PlayerEditForm.overallMoreKey,
            tooltip: l.editorPlayerMore,
            onPressed: overall < 99 ? () => _rate(overall + 1, type) : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      Slider(
        key: PlayerEditForm.overallKey,
        min: 1,
        max: 99,
        divisions: 98,
        value: overall.toDouble(),
        label: '$overall',
        onChangeStart: (_) => _overallRun = Object(),
        onChanged: (v) =>
            _rate(v.round(), _type ?? type, group: _overallRun ??= Object()),
        onChangeEnd: (_) => _overallRun = null,
      ),
    ],
  );

  Widget _types(AppLocalizations l, int overall, PlayerType type) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _label(l.editorPlayerType),
      Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (final t in PlayerType.values)
            ChoiceChip(
              key: PlayerEditForm.typeKey(t),
              label: Text(playerTypeLabel(l, t)),
              selected: type == t,
              onSelected: (_) {
                _rate(overall, t);
                setState(() {});
              },
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        playerTypeAbout(l, type),
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ],
  );

  Widget _qualities(AppLocalizations l, PackPlayer p) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _label(l.editorPlayerQualities),
      StatBar(label: l.playerAttrPhysical, value: p.attributes.physical),
      const SizedBox(height: AppSpacing.xs),
      StatBar(label: l.playerAttrTechnical, value: p.attributes.technical),
      const SizedBox(height: AppSpacing.xs),
      StatBar(label: l.playerAttrStamina, value: p.attributes.stamina),
    ],
  );

  Widget _potential(AppLocalizations l, PackPlayer p, int overall) {
    final open = overall < 99;
    final value = p.potential.clamp(overall, 99);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _label(l.editorPlayerPotential)),
            Text(
              '$value',
              style: AppTypography.headlineMedium.copyWith(
                color: overallColor(value),
              ),
            ),
          ],
        ),
        Slider(
          key: PlayerEditForm.potentialKey,
          min: overall.toDouble(),
          max: 99,
          divisions: open ? 99 - overall : null,
          value: value.toDouble(),
          label: '$value',
          onChangeStart: (_) => _potentialRun = Object(),
          onChanged: open
              ? (v) => _edit(
                  (p) => SquadEdits.withPotential(p, v.round()),
                  group: _potentialRun ??= Object(),
                )
              : null,
          onChangeEnd: (_) => _potentialRun = null,
        ),
        Text(
          l.editorPlayerPotentialAbout,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// − value +.
class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.valueKey,
    required this.lessKey,
    required this.moreKey,
    required this.value,
    required this.onLess,
    required this.onMore,
  });

  final Key valueKey;
  final Key lessKey;
  final Key moreKey;
  final int value;
  final VoidCallback? onLess;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          key: lessKey,
          tooltip: l.editorPlayerLess,
          onPressed: onLess,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 48,
          child: Text(
            '$value',
            key: valueKey,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium,
          ),
        ),
        IconButton.filledTonal(
          key: moreKey,
          tooltip: l.editorPlayerMore,
          onPressed: onMore,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

/// A club the picker offers: `club` as stored (null: the game places him),
/// `country` its league's FIFA code, `label` how it reads.
typedef _ClubOption = ({String? club, String? country, String label});

/// The clubs a player of the nation with FIFA code [code] can be given:
/// the game's choice, no club, his present club when it is elsewhere, and
/// the clubs of his country's league, each under the pack's name for it.
List<_ClubOption> _clubOptions(
  AppLocalizations l,
  WorldPack pack,
  PackPlayer p,
  String code,
) {
  final league = ClubService.leagueClubs(code);
  final country = code.toLowerCase();
  return [
    (club: null, country: null, label: l.editorPlayerClubAuto),
    (
      club: ClubService.freeAgent,
      country: null,
      label: l.editorPlayerFreeAgent,
    ),
    if (p.club != null &&
        p.club != ClubService.freeAgent &&
        !(league.contains(p.club) && p.clubCountry == country))
      (
        club: p.club,
        country: p.clubCountry,
        label: pack.clubs[p.club] ?? p.club!,
      ),
    for (final c in league)
      (club: c, country: country, label: pack.clubs[c] ?? c),
  ];
}

/// Search and pick a club.
class _ClubPicker extends StatefulWidget {
  const _ClubPicker({required this.options, required this.current});

  final List<_ClubOption> options;
  final String? current;

  @override
  State<_ClubPicker> createState() => _ClubPickerState();
}

class _ClubPickerState extends State<_ClubPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final q = searchFold(_query);
    final shown = [
      for (final o in widget.options)
        if (q.isEmpty ||
            searchFold(o.label).contains(q) ||
            searchFold(o.club ?? '').contains(q))
          o,
    ];
    final height = MediaQuery.sizeOf(context).height * 0.7;
    return SizedBox(
      height: height.clamp(320, 640),
      width: 480,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                l.editorPlayerClubPick,
                style: AppTypography.titleMedium,
              ),
            ),
            TextField(
              key: PlayerEditForm.clubSearchKey,
              onChanged: (v) => setState(() => _query = v),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: l.editorPlayerClubSearch,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: shown.isEmpty
                  ? EditorMessage(l.editorPlayerClubNone)
                  : ListView.builder(
                      itemCount: shown.length,
                      itemBuilder: (context, i) {
                        final o = shown[i];
                        final selected = o.club == widget.current;
                        return ListTile(
                          key: PlayerEditForm.clubOptionKey(o.club),
                          leading: (o.country ?? '').isNotEmpty
                              ? FlagDisc(o.country!, size: 28)
                              : const Icon(Icons.shield_outlined),
                          title: Text(
                            o.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: o.club == null
                              ? Text(l.editorPlayerClubAutoAbout)
                              : null,
                          trailing: selected
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                )
                              : null,
                          onTap: () => Navigator.of(context).pop(o),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
