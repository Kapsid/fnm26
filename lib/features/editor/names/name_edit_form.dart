import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Edits one row of a name section: its name (and a nation's code or a
/// reporter's outlet), or a nation's two name lists.
///
/// It saves as it is typed. A value that cannot be used (a code another
/// nation has, a Y name another account has, characters that cannot be
/// shown) is refused with a message and not saved. Everything typed in one
/// opening of the form is one undo step; "Reset to original" removes the
/// override.
class NameEditForm extends ConsumerStatefulWidget {
  const NameEditForm({
    required this.packId,
    required this.section,
    required this.entry,
    required this.world,
    this.onDone,
    super.key,
  });

  static const Key nameKey = Key('editorNames.form.name');
  static const Key codeKey = Key('editorNames.form.code');
  static const Key outletKey = Key('editorNames.form.outlet');
  static const Key firstNamesKey = Key('editorNames.form.first');
  static const Key surnamesKey = Key('editorNames.form.sur');
  static const Key resetKey = Key('editorNames.form.reset');
  static const Key doneKey = Key('editorNames.form.done');

  final int packId;
  final NameSection section;
  final NameEntry entry;

  /// The nations of the database, for a code another nation already has.
  final List<Nation> world;

  /// Closes the form (the phone's sheet); null shows no Done button.
  final VoidCallback? onDone;

  @override
  ConsumerState<NameEditForm> createState() => _NameEditFormState();
}

class _NameEditFormState extends ConsumerState<NameEditForm> {
  final _name = TextEditingController();
  final _second = TextEditingController();
  final _first = TextEditingController();
  final _sur = TextEditingController();

  /// This opening's undo group: everything typed here is one undo step.
  Object _group = Object();

  /// The pack this form last wrote: any other (an undo) is read back in.
  WorldPack? _mine;

  NameSection get _section => widget.section;
  NameEntry get _e => widget.entry;
  PackEditor get _editor =>
      ref.read(packEditorProvider(widget.packId).notifier);

  @override
  void initState() {
    super.initState();
    _fill(ref.read(packEditorProvider(widget.packId)).valueOrNull);
  }

  @override
  void dispose() {
    _name.dispose();
    _second.dispose();
    _first.dispose();
    _sur.dispose();
    super.dispose();
  }

  /// The fields as [pack] has them: its names, else the game's.
  void _fill(WorldPack? pack) {
    if (pack == null) return;
    if (_section == NameSection.nameLists) {
      final lists = NameEdits.listsOf(pack, _e);
      _set(_first, lists.first.join(', '));
      _set(_sur, lists.sur.join(', '));
      return;
    }
    final o = nameOverride(_section, pack, _e);
    _set(_name, ActiveWorld.textOrNull(o?.name) ?? _e.original);
    _set(_second, ActiveWorld.textOrNull(o?.second) ?? _e.original2);
  }

  static void _set(TextEditingController c, String text) {
    if (c.text == text) return;
    c.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// What is wrong with the name and the second field as typed, in words.
  ({String? name, String? second}) _errors(
    AppLocalizations l,
    WorldPack pack,
  ) {
    String? nameProblem(String v, {int? max}) {
      if (v.trim().isEmpty) return null;
      final m = max ?? _section.maxLength;
      return switch (PackRules.checkName(v, max: m)) {
        FieldReason.tooLong => l.editorNameTooLong(m),
        FieldReason.badCharacters => l.editorNameBadCharacters,
        FieldReason.duplicate => l.editorNamesTaken,
        FieldReason.empty || FieldReason.outOfRange || null => null,
      };
    }

    var name = nameProblem(_name.text);
    if (name == null && _section == NameSection.yAccounts) {
      final next = NameEdits.rename(_section, pack, _e, _name.text);
      if (PackRules.yNameTaken(next.yAccounts, _e.key)) {
        name = l.editorNamesTaken;
      }
    }
    final second = switch (_section) {
      NameSection.nations => _codeProblem(l, pack),
      NameSection.press => nameProblem(_second.text, max: PackRules.nameMax),
      _ => null,
    };
    return (name: name, second: second);
  }

  /// A nation code must be 3 letters and nobody else's: not another
  /// nation's code in this database (its new one, or the game's).
  String? _codeProblem(AppLocalizations l, WorldPack pack) {
    final code = _second.text.trim().toUpperCase();
    if (code.isEmpty) return null;
    if (PackRules.checkCode(code) != null) return l.editorIssueCode;
    final byId = {for (final n in widget.world) n.id: n};
    for (final n in widget.world) {
      if (n.id == _e.nationId) continue;
      final theirs = ActiveWorld.textOrNull(pack.nations[n.id]?.code) ?? n.code;
      if (theirs.toUpperCase() == code) {
        return l.editorNamesCodeTaken(code, packNationName(pack, byId, n.id));
      }
    }
    return null;
  }

  /// Saves the fields as typed, when they can be used.
  void _changed() {
    final pack = ref.read(packEditorProvider(widget.packId)).valueOrNull;
    if (pack == null) return;
    final l = AppLocalizations.of(context);
    setState(() {});
    if (_section == NameSection.nameLists) {
      _write(
        (p) => NameEdits.withLists(
          p,
          _e,
          NameEdits.parseNames(_first.text),
          NameEdits.parseNames(_sur.text),
        ),
        group: _group,
      );
      return;
    }
    final errors = _errors(l, pack);
    if (errors.name != null || errors.second != null) return;
    _write(
      (p) => NameEdits.rename(_section, p, _e, _name.text, _second.text),
      group: _group,
    );
  }

  /// Whether this form is writing right now: what the pack tells its
  /// listeners meanwhile is this form's own edit.
  bool _writing = false;

  void _write(WorldPack Function(WorldPack) edit, {Object? group}) {
    _writing = true;
    try {
      _editor.update(edit, group: group);
    } finally {
      _writing = false;
    }
    _mine = ref.read(packEditorProvider(widget.packId)).valueOrNull;
  }

  void _reset() {
    _write((p) => NameEdits.reset(_section, p, _e));
    // Typing after a reset is a step of its own.
    _group = Object();
    setState(() => _fill(_mine));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    ref.listen(packEditorProvider(widget.packId), (_, next) {
      final pack = next.valueOrNull;
      if (pack == null || _writing || identical(pack, _mine)) return;
      // Changed elsewhere (an undo): show what the pack now holds.
      _group = Object();
      setState(() => _fill(pack));
    });
    final pack = ref.watch(packEditorProvider(widget.packId)).valueOrNull;
    if (pack == null) return const SizedBox.shrink();
    final changed = _section == NameSection.nameLists
        ? pack.nameLists.containsKey(int.tryParse(_e.key))
        : nameOverride(_section, pack, _e) != null;

    final fields = _section == NameSection.nameLists
        ? _listFields(l)
        : _nameFields(l, _errors(l, pack));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Header(entry: _e, section: _section, changed: changed),
        const SizedBox(height: AppSpacing.md),
        ...fields,
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              key: NameEditForm.resetKey,
              onPressed: changed ? _reset : null,
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
              icon: const Icon(Icons.restart_alt),
              label: Text(l.editorNamesReset),
            ),
            if (widget.onDone != null)
              FilledButton(
                key: NameEditForm.doneKey,
                onPressed: widget.onDone,
                style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
                child: Text(l.editorNamesDone),
              ),
          ],
        ),
      ],
    );
  }

  List<Widget> _nameFields(
    AppLocalizations l,
    ({String? name, String? second}) errors,
  ) {
    final style = AppTypography.bodyLarge.copyWith(color: AppColors.onSurface);
    return [
      TextField(
        key: NameEditForm.nameKey,
        controller: _name,
        maxLength: _section.maxLength,
        textCapitalization: TextCapitalization.words,
        textInputAction: _section.paired
            ? TextInputAction.next
            : TextInputAction.done,
        style: style,
        onChanged: (_) => _changed(),
        onSubmitted: (_) {
          if (!_section.paired) widget.onDone?.call();
        },
        decoration: InputDecoration(
          labelText: l.editorNameLabel,
          helperText: l.editorNamesKeepHint,
          helperMaxLines: 2,
          errorText: errors.name,
          errorMaxLines: 2,
        ),
      ),
      if (_section == NameSection.nations) ...[
        const SizedBox(height: AppSpacing.sm),
        TextField(
          key: NameEditForm.codeKey,
          controller: _second,
          maxLength: PackRules.codeLength,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
            const _UpperCase(),
          ],
          style: style.copyWith(letterSpacing: 2),
          onChanged: (_) => _changed(),
          onSubmitted: (_) => widget.onDone?.call(),
          decoration: InputDecoration(
            labelText: l.editorNamesCode,
            helperText: l.editorNamesCodeHelp,
            helperMaxLines: 2,
            errorText: errors.second,
            errorMaxLines: 2,
          ),
        ),
      ],
      if (_section == NameSection.press) ...[
        const SizedBox(height: AppSpacing.sm),
        TextField(
          key: NameEditForm.outletKey,
          controller: _second,
          maxLength: PackRules.nameMax,
          textCapitalization: TextCapitalization.words,
          style: style,
          onChanged: (_) => _changed(),
          onSubmitted: (_) => widget.onDone?.call(),
          decoration: InputDecoration(
            labelText: l.editorNamesOutlet,
            helperText: l.editorNamesKeepHint,
            helperMaxLines: 2,
            errorText: errors.second,
            errorMaxLines: 2,
          ),
        ),
      ],
    ];
  }

  List<Widget> _listFields(AppLocalizations l) {
    const min = PackRules.nameListMin;
    Widget list(
      Key key,
      TextEditingController c,
      String label,
      String Function(int count, int min) count,
    ) {
      final names = NameEdits.parseNames(c.text);
      final short = names.length < min;
      final bad = names.firstWhere(
        (n) => PackRules.checkName(n) != null,
        orElse: () => '',
      );
      return TextField(
        key: key,
        controller: c,
        minLines: 3,
        maxLines: 8,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.words,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
        onChanged: (_) => _changed(),
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          errorText: bad.isEmpty
              ? null
              : switch (PackRules.checkName(bad)) {
                  FieldReason.tooLong => l.editorIssueNameTooLong(bad),
                  _ => l.editorIssueNameBadCharacters(bad),
                },
          errorMaxLines: 2,
          helper: Row(
            children: [
              Icon(
                short ? Icons.pending_outlined : Icons.check_circle,
                size: 14,
                color: short ? AppColors.warning : AppColors.positive,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  count(names.length, min),
                  style: AppTypography.bodySmall.copyWith(
                    color: short ? AppColors.warning : AppColors.positive,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return [
      Text(
        l.editorNamesListsHelp(min),
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      list(
        NameEditForm.firstNamesKey,
        _first,
        l.editorNamesFirstNames,
        l.editorNamesFirstCount,
      ),
      const SizedBox(height: AppSpacing.md),
      list(
        NameEditForm.surnamesKey,
        _sur,
        l.editorNamesSurnames,
        l.editorNamesSurCount,
      ),
    ];
  }
}

/// The game's name for what is edited, with its flag and what it is.
class _Header extends StatelessWidget {
  const _Header({
    required this.entry,
    required this.section,
    required this.changed,
  });

  final NameEntry entry;
  final NameSection section;
  final bool changed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final about = [
      ?entry.detail,
      if (entry.original2.isNotEmpty) entry.original2,
    ].join(' · ');
    return Row(
      children: [
        if (entry.flagCode case final code?) ...[
          FlagDisc(code, size: 40),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.editorNamesGameName(entry.original),
                style: AppTypography.labelLarge,
              ),
              if (about.isNotEmpty)
                Text(
                  about,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (changed) const NameChangedMark(),
      ],
    );
  }
}

/// The small "Changed" mark of a row the database renames.
class NameChangedMark extends StatelessWidget {
  const NameChangedMark({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: AppRadii.lgAll,
      ),
      child: Text(
        l.editorNamesChanged,
        style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
      ),
    );
  }
}

/// Capital letters as they are typed.
class _UpperCase extends TextInputFormatter {
  const _UpperCase();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
