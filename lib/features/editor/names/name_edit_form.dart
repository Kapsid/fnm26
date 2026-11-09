import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/club_strength_picker.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Edits one row of a name section: its name (and a reporter's outlet), or
/// a nation's two name lists.
///
/// Under a [language] it edits that language's own name: left empty, or
/// typed as the main name, there is none and the main name shows; "Use the
/// main name" removes it. Under All languages (null) it edits the main
/// name, and "Reset to original" removes it with every language's own.
///
/// It saves as it is typed. A value that cannot be used (a Y name another
/// account has, characters that cannot be shown, one name per language too
/// many for the database) is refused with a message and not saved.
/// Everything typed in one opening of the form is one undo step.
class NameEditForm extends ConsumerStatefulWidget {
  const NameEditForm({
    required this.packId,
    required this.section,
    required this.entry,
    required this.world,
    this.language,
    this.onDone,
    super.key,
  });

  static const Key nameKey = Key('editorNames.form.name');
  static const Key outletKey = Key('editorNames.form.outlet');
  static const Key firstNamesKey = Key('editorNames.form.first');
  static const Key surnamesKey = Key('editorNames.form.sur');
  static const Key resetKey = Key('editorNames.form.reset');
  static const Key doneKey = Key('editorNames.form.done');

  final int packId;
  final NameSection section;
  final NameEntry entry;

  /// The nations of the database.
  final List<Nation> world;

  /// The editor's language whose own names this edits, or null for the
  /// main names (All languages).
  final String? language;

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

  /// Whether the row has a second text: a reporter's outlet, an added
  /// sponsor's description.
  bool get _hasSecond => NameEdits.pathsOf(_section, _e).length > 1;

  /// The longest second text.
  int get _secondMax => _e.added ? PackRules.descriptionMax : PackRules.nameMax;
  String? get _lang => widget.language;
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
    if (_lang case final lang?) {
      // Only the language's own: empty shows what it falls back to.
      final v = valueIn(_section, pack, _e, lang);
      _set(_name, v.name.own ?? '');
      _set(_second, v.second?.own ?? '');
      return;
    }
    final o = nameOverride(_section, pack, _e);
    _set(_name, ActiveWorld.textOrNull(o?.name) ?? _e.original);
    _set(_second, ActiveWorld.textOrNull(o?.second) ?? _e.original2);
  }

  /// The pack with the fields as typed: in the editor's language, or as
  /// the main names.
  WorldPack _edited(WorldPack p) => switch (_lang) {
    final lang? => NameEdits.renameIn(
      _section,
      p,
      _e,
      lang,
      _name.text,
      _second.text,
    ),
    null => NameEdits.rename(_section, p, _e, _name.text, _second.text),
  };

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
    final second = _hasSecond
        ? nameProblem(_second.text, max: _secondMax)
        : null;
    if (name != null || second != null) {
      return (name: name, second: second);
    }
    final lang = _lang;
    if (lang != null) {
      // Refused before it is stored: one value per language too many for
      // the database, or a Y name another account shows in this language.
      if (NameEdits.overflowsIn(
        _section,
        pack,
        _e,
        lang,
        _name.text,
        _second.text,
      )) {
        return (name: l.editorLanguageFull, second: null);
      }
      if (_section == NameSection.yAccounts &&
          PackRules.yNameTakenIn(
            _edited(pack),
            NameEdits.pathsOf(_section, _e).first,
            lang,
          )) {
        name = l.editorNamesTaken;
      }
    } else if (_section == NameSection.clubs && !_e.added) {
      // A league club renamed onto a club the database adds to its
      // country: the same check an added club's name gets.
      final code = widget.world
          .where((n) => n.id == _e.nationId)
          .firstOrNull
          ?.code;
      if (code != null &&
          PackRules.clubNameClash(
                pack,
                _name.text,
                code.toLowerCase(),
                _editor.countryCities,
                renamedFrom: _e.key,
              ) ==
              ClubNameClash.added) {
        name = l.editorNamesTaken;
      }
    } else if (_section == NameSection.yAccounts) {
      final next = NameEdits.rename(_section, pack, _e, _name.text);
      if (PackRules.yNameTaken(
        next.yAccounts,
        _e.key,
        added: pack.addedYAccounts,
      )) {
        name = l.editorNamesTaken;
      }
    }
    return (name: name, second: second);
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
    _write(_edited, group: _group);
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

  /// Under a language, its own names go ("Use the main name"); under All
  /// languages, everything of the row ("Reset to original").
  void _reset() {
    _write(
      (p) => switch (_lang) {
        final lang? => NameEdits.resetIn(_section, p, _e, lang),
        null => NameEdits.reset(_section, p, _e),
      },
    );
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
    final lang = _lang;
    final inLanguage = lang == null ? null : valueIn(_section, pack, _e, lang);
    final changed = switch (_section) {
      NameSection.nameLists => pack.nameLists.containsKey(int.tryParse(_e.key)),
      _ when inLanguage != null =>
        inLanguage.name.own != null || inLanguage.second?.own != null,
      _ =>
        nameOverride(_section, pack, _e) != null ||
            languagesOf(_section, pack, _e).isNotEmpty,
    };

    final fields = _section == NameSection.nameLists
        ? _listFields(l)
        : _nameFields(l, _errors(l, pack), inLanguage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Header(
          entry: _e,
          section: _section,
          changed: changed,
          language: lang,
          inLanguage: inLanguage?.name,
        ),
        const SizedBox(height: AppSpacing.md),
        ...fields,
        // A league club's strength: one for every language, so it is set
        // under All languages only.
        if (_section == NameSection.clubs && !_e.added && lang == null) ...[
          const SizedBox(height: AppSpacing.sm),
          ClubStrengthPicker(
            value: pack.clubStrengths[_e.key],
            defaultStars: clubDefaultStars(_e),
            onChanged: (stars) {
              _write((p) => NameEdits.withClubStrength(p, _e.key, stars));
              // A pick is a step of its own.
              _group = Object();
              setState(() {});
            },
          ),
        ],
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
              label: Text(
                lang == null ? l.editorNamesReset : l.editorLanguageClear,
              ),
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
    ({LanguageValue name, LanguageValue? second})? inLanguage,
  ) {
    final style = AppTypography.bodyLarge.copyWith(color: AppColors.onSurface);
    // Under a language an empty field is no name of its own: its hint is
    // what then shows (the main name, else the game's there).
    final hint = inLanguage == null
        ? l.editorNamesKeepHint
        : l.editorLanguageKeepHint;
    String? fallback(LanguageValue? v) => v == null ? null : v.main ?? v.game;
    return [
      TextField(
        key: NameEditForm.nameKey,
        controller: _name,
        maxLength: _section.maxLength,
        textCapitalization: TextCapitalization.words,
        textInputAction: _hasSecond
            ? TextInputAction.next
            : TextInputAction.done,
        style: style,
        onChanged: (_) => _changed(),
        onSubmitted: (_) {
          if (!_hasSecond) widget.onDone?.call();
        },
        decoration: InputDecoration(
          labelText: l.editorNameLabel,
          hintText: fallback(inLanguage?.name),
          helperText: hint,
          helperMaxLines: 2,
          errorText: errors.name,
          errorMaxLines: 2,
        ),
      ),
      if (_hasSecond) ...[
        const SizedBox(height: AppSpacing.sm),
        TextField(
          key: NameEditForm.outletKey,
          controller: _second,
          maxLength: _secondMax,
          // An added sponsor's description runs over lines.
          minLines: _e.added ? 2 : 1,
          maxLines: _e.added ? 4 : 1,
          textCapitalization: _e.added
              ? TextCapitalization.sentences
              : TextCapitalization.words,
          style: style,
          onChanged: (_) => _changed(),
          onSubmitted: (_) => widget.onDone?.call(),
          decoration: InputDecoration(
            labelText: _e.added
                ? l.editorAddedDescription
                : l.editorNamesOutlet,
            hintText: fallback(inLanguage?.second),
            helperText: hint,
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

/// The game's name for what is edited, with its flag and what it is; under
/// a [language], the game's name there and the database's main name.
class _Header extends StatelessWidget {
  const _Header({
    required this.entry,
    required this.section,
    required this.changed,
    this.language,
    this.inLanguage,
  });

  final NameEntry entry;
  final NameSection section;
  final bool changed;
  final String? language;

  /// The name in [language], when one is picked.
  final LanguageValue? inLanguage;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final v = inLanguage;
    final about = [
      ?entry.detail,
      if (entry.original2.isNotEmpty) entry.original2,
    ].join(' · ');
    final muted = AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
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
                // An added item has no game name: its main one heads it.
                entry.added
                    ? l.editorLanguageMainName(entry.original)
                    : l.editorNamesGameName(v?.game ?? entry.original),
                style: AppTypography.labelLarge,
              ),
              if (about.isNotEmpty) Text(about, style: muted),
              if (v?.main case final main?)
                Text(l.editorLanguageMainName(main), style: muted),
            ],
          ),
        ),
        if (changed) NameChangedMark(language: language),
      ],
    );
  }
}

/// The small "Changed" mark of a row the database renames; under a picked
/// [language], that language's code (it has a name of its own there).
class NameChangedMark extends StatelessWidget {
  const NameChangedMark({this.language, super.key});

  final String? language;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final code = language;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: AppRadii.lgAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (code != null) ...[
            const Icon(Icons.translate, size: 12, color: AppColors.primary),
            const SizedBox(width: 3),
          ],
          Text(
            code == null ? l.editorNamesChanged : code.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
