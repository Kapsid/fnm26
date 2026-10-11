// Reads back the file `tool/export_copy.dart` wrote and puts the edited text
// into the ARB files (every language whose
// `lib/l10n/app_<code>.arb` exists).
//
//   dart run tool/import_copy.dart                 → copy/strings.csv
//   dart run tool/import_copy.dart other.csv
//   dart run tool/import_copy.dart --dry-run       → say what would change
//
// Takes the CSV the exporter writes, and a TAB-separated file too — a
// spreadsheet that insists on exporting tabs is a thing that happens, and
// refusing the file over a delimiter would be a refusal about nothing.
//
// Then `flutter gen-l10n` to rebuild AppLocalizations.
//
// SAFE BY REFUSAL. Every row is checked against the string it is replacing
// before anything is written, and if ANY row fails the whole import is
// abandoned — a half-applied rewrite is the one outcome worse than none. What
// gets a row refused:
//
//   * a key that is not in the app (a typo, or a string deleted since export);
//   * placeholders that do not match the original, in any language. A
//     `{player}` renamed to `{name}` compiles perfectly and throws in front of
//     a player the first time that screen opens, which is exactly the class of
//     mistake a hand-edited copy file invites;
//   * a plural whose `{count, plural, …}` skeleton has been rewritten: a
//     translation must keep the plural and its variable and an `other{`
//     branch, but may use other categories (Polish has `few` and `many`).
//
// Key order, every `@`-metadata block and every description are preserved
// untouched: this writes VALUES and nothing else.
import 'dart:convert';
import 'dart:io';

import 'copy_format.dart';

String _arbPath(String code) => 'lib/l10n/app_$code.arb';

/// Where the exporter writes, and where a `.csv` that has been round-tripped
/// through a spreadsheet is most likely to be.
const List<String> _defaultPaths = ['copy/strings.csv', 'copy/strings.tsv'];

void main(List<String> args) {
  final dryRun = args.contains('--dry-run');
  final positional = args.where((a) => !a.startsWith('--')).toList();
  final source = positional.isEmpty
      ? _defaultPaths.map(File.new).where((f) => f.existsSync()).firstOrNull
      : File(positional.first);
  if (source == null) {
    _fail(
      'no copy file found (looked for ${_defaultPaths.join(" and ")}) — '
      'run tool/export_copy.dart first',
    );
  }
  if (!source.existsSync()) {
    _fail('no such file: ${source.path} — run tool/export_copy.dart first');
  }

  // Only languages whose ARB exists are imported; English always does.
  final langs = [
    for (final code in kLanguages)
      if (File(_arbPath(code)).existsSync()) code,
  ];
  final arbs = {for (final code in langs) code: _readArb(_arbPath(code))};
  final en = arbs['en']!;

  final lines = source.readAsLinesSync();
  if (lines.isEmpty) _fail('${source.path} is empty');
  // A leading BOM if a spreadsheet put one back; it is not part of the header.
  final header = lines.first.replaceFirst('\uFEFF', '');
  final delimiter = delimiterOf(header);
  if (delimiter == null) {
    _fail(
      'the first line must be the column header, comma- or tab-separated:\n'
      '  ${kColumns.join(',')}\n'
      'found:\n  $header\n'
      'If a spreadsheet rewrote it, re-export and paste your edits back in.',
    );
  }

  final problems = <String>[];
  final changes = {for (final code in langs) code: <String, String>{}};

  for (var i = 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    final f = decodeRow(line, delimiter);
    final where = 'line ${i + 1}';
    if (f.length < kColumns.length) {
      problems.add(
        '$where: expected ${kColumns.length} columns, found ${f.length}',
      );
      continue;
    }
    final key = f[0].trim();
    final newEn = unescapeValue(f[columnOf('en')]);

    final oldEn = en[key];
    if (oldEn is! String) {
      problems.add('$where: "$key" is not a string in ${_arbPath('en')}');
      continue;
    }
    if (newEn.trim().isEmpty) {
      problems.add('$where: "$key" has no English text');
      continue;
    }
    final shapeEn = _shapeProblem(key, oldEn, newEn, 'English');
    if (shapeEn != null) problems.add('$where: $shapeEn');
    if (newEn != oldEn) changes['en']![key] = newEn;

    // Every other language is checked against the ENGLISH, which is the
    // template: a translation carries the same placeholders as the string it
    // translates, whatever its own file happened to hold before. A blank cell
    // keeps what is there.
    for (final code in langs.skip(1)) {
      final value = unescapeValue(f[columnOf(code)]);
      if (value.trim().isEmpty) continue;
      final shape = _shapeProblem(key, oldEn, value, code);
      if (shape != null) problems.add('$where: $shape');
      if (value != arbs[code]![key]) changes[code]![key] = value;
    }
  }

  if (problems.isNotEmpty) {
    stderr.writeln(
      'Refused — nothing was written. ${problems.length} '
      'problem(s):\n',
    );
    for (final p in problems) {
      stderr.writeln('  • $p');
    }
    exit(1);
  }

  stdout.writeln(
    [
          for (final code in langs) '${changes[code]!.length} $code',
        ].join(', ') +
        ' string(s) changed.',
  );
  final touched = {for (final c in changes.values) ...c.keys};
  if (dryRun) {
    for (final key in touched) {
      stdout.writeln('  $key');
    }
    stdout.writeln('\nDry run — nothing written.');
    return;
  }
  if (touched.isEmpty) return;

  for (final code in langs) {
    final c = changes[code]!;
    if (c.isEmpty) continue;
    c.forEach((k, v) => arbs[code]![k] = v);
    _writeArb(_arbPath(code), arbs[code]!);
  }
  stdout.writeln('Written. Now run:  flutter gen-l10n');
}

/// Why [replacement] cannot stand in for [original], or null when it can.
String? _shapeProblem(
  String key,
  String original,
  String replacement,
  String language,
) {
  final wasPlural = _isPlural(original);
  if (wasPlural != _isPlural(replacement)) {
    return '"$key" ($language): the {count, plural, …} skeleton was '
        '${wasPlural ? "removed" : "added"} — keep it exactly as exported and '
        'translate only the words inside its branches';
  }
  // Inside a plural the branch selectors ({count}, one, other) are machinery,
  // and languages have different categories (Polish adds few and many), so
  // only the variable and the mandatory `other{` branch are checked.
  if (wasPlural) {
    final variable = _pluralVariable(original);
    if (_pluralVariable(replacement) != variable) {
      return '"$key" ($language): the plural must count {$variable}';
    }
    if (!RegExp(r'\bother\s*\{').hasMatch(replacement)) {
      return '"$key" ($language): the plural has no other{…} branch';
    }
    return null;
  }
  final before = _placeholders(original);
  final after = _placeholders(replacement);
  if (before.difference(after).isNotEmpty) {
    final lost = before.difference(after).map((p) => '{$p}').join(', ');
    return '"$key" ($language): lost $lost — the code passes it and the '
        'string must use it';
  }
  if (after.difference(before).isNotEmpty) {
    final extra = after.difference(before).map((p) => '{$p}').join(', ');
    return '"$key" ($language): has $extra, which nothing passes it';
  }
  return null;
}

/// The variable a `{count, plural, …}` counts (or selects on).
String? _pluralVariable(String v) =>
    RegExp(r'\{\s*(\w+)\s*,\s*(plural|select)').firstMatch(v)?.group(1);

bool _isPlural(String v) =>
    RegExp(r'\{\s*\w+\s*,\s*(plural|select)').hasMatch(v);

Set<String> _placeholders(String v) => {
  for (final m in RegExp(r'\{(\w+)\}').allMatches(v)) m.group(1)!,
};

Map<String, Object?> _readArb(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

/// Writes the ARB back with the formatting the repository uses — two-space
/// indent, real UTF-8, trailing newline — so an import that changes one string
/// produces a one-line diff rather than reformatting the file.
void _writeArb(String path, Map<String, Object?> data) {
  const encoder = JsonEncoder.withIndent('  ');
  File(path).writeAsStringSync('${encoder.convert(data)}\n');
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
