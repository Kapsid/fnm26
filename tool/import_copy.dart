// Reads back the file `tool/export_copy.dart` wrote and puts the edited text
// into the two ARB files.
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
//   * placeholders that do not match the original, in either language. A
//     `{player}` renamed to `{name}` compiles perfectly and throws in front of
//     a player the first time that screen opens, which is exactly the class of
//     mistake a hand-edited copy file invites;
//   * a plural whose `{count, plural, …}` skeleton has been rewritten.
//
// Key order, every `@`-metadata block and every description are preserved
// untouched: this writes VALUES and nothing else.
import 'dart:convert';
import 'dart:io';

import 'copy_format.dart';

const String _enPath = 'lib/l10n/app_en.arb';
const String _csPath = 'lib/l10n/app_cs.arb';

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

  final en = _readArb(_enPath);
  final cs = _readArb(_csPath);

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
  final enChanges = <String, String>{};
  final csChanges = <String, String>{};

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
    final newEn = unescapeValue(f[3]);
    final newCs = unescapeValue(f[4]);

    final oldEn = en[key];
    if (oldEn is! String) {
      problems.add('$where: "$key" is not a string in $_enPath');
      continue;
    }
    if (newEn.trim().isEmpty) {
      problems.add('$where: "$key" has no English text');
      continue;
    }
    final shapeEn = _shapeProblem(key, oldEn, newEn, 'English');
    if (shapeEn != null) problems.add('$where: $shapeEn');

    // The Czech is checked against the ENGLISH, which is the template: a
    // translation carries the same placeholders as the string it translates,
    // whatever the Czech file happened to hold before.
    if (newCs.trim().isNotEmpty) {
      final shapeCs = _shapeProblem(key, oldEn, newCs, 'Czech');
      if (shapeCs != null) problems.add('$where: $shapeCs');
    }

    if (newEn != oldEn) enChanges[key] = newEn;
    if (newCs.trim().isNotEmpty && newCs != cs[key]) csChanges[key] = newCs;
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
    '${enChanges.length} English and ${csChanges.length} Czech '
    'string(s) changed.',
  );
  if (dryRun) {
    for (final key in {...enChanges.keys, ...csChanges.keys}) {
      stdout.writeln('  $key');
    }
    stdout.writeln('\nDry run — nothing written.');
    return;
  }
  if (enChanges.isEmpty && csChanges.isEmpty) return;

  enChanges.forEach((k, v) => en[k] = v);
  csChanges.forEach((k, v) => cs[k] = v);
  _writeArb(_enPath, en);
  _writeArb(_csPath, cs);
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
  // so only the simple case can be compared name for name.
  if (wasPlural) return null;
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
