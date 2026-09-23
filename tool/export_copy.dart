// Exports every string in the app to one spreadsheet file you can edit by
// hand, and which `tool/import_copy.dart` reads back.
//
//   dart run tool/export_copy.dart          → copy/strings.csv
//   dart run tool/export_copy.dart out.csv  → somewhere else
//
// CSV, five columns: key, where, placeholders, en, cs. It opens by
// double-click in Numbers and Excel, and quoting is handled properly, so a
// comma inside a sentence is just a comma.
//
// WHAT YOU MAY CHANGE: the `en` and `cs` columns, and nothing else. The key is
// what the code asks for, `where` and `placeholders` are notes for you, and
// the importer checks the placeholders you leave behind against the ones the
// string started with — a `{player}` renamed or dropped compiles fine and
// crashes in front of a player, so a row that loses one is refused by name.
import 'dart:convert';
import 'dart:io';

import 'copy_format.dart';

void main(List<String> args) {
  final out = File(args.isEmpty ? 'copy/strings.csv' : args.first);
  final en = _readArb('lib/l10n/app_en.arb');
  final cs = _readArb('lib/l10n/app_cs.arb');

  final lines = <String>[encodeRow(kColumns)];
  var written = 0;
  for (final entry in en.entries) {
    final key = entry.key;
    if (key.startsWith('@')) continue;
    final value = entry.value;
    if (value is! String) continue;
    final meta = en['@$key'];
    lines.add(
      encodeRow([
        key,
        meta is Map ? (meta['description'] as String? ?? '') : '',
        _placeholderNote(value),
        value,
        cs[key] is String ? cs[key]! as String : '',
      ]),
    );
    written++;
  }

  out.parent.createSync(recursive: true);
  // A BOM, so Excel opens it as UTF-8 rather than mangling every Czech
  // diacritic. Numbers, a text editor and the importer all ignore it.
  out.writeAsStringSync('﻿${lines.join('\n')}\n');
  stdout.writeln('Wrote $written strings to ${out.path}.');
  stdout.writeln('Edit the `en` and `cs` columns, then:');
  stdout.writeln('  dart run tool/import_copy.dart ${out.path}');
}

Map<String, Object?> _readArb(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

/// The placeholders a string uses, as a note for whoever is editing it.
///
/// A plural or select is flagged rather than listed: its `{count, plural, …}`
/// skeleton is machinery, not prose, and the note has to say so — a translator
/// who rewrites the `one{}` / `other{}` branches out of it breaks the string.
String _placeholderNote(String value) {
  if (RegExp(r'\{\s*\w+\s*,\s*(plural|select)').hasMatch(value)) {
    return 'PLURAL — keep the {count, plural, …} skeleton exactly; '
        'translate only the words inside the branches';
  }
  final names = <String>{
    for (final m in RegExp(r'\{(\w+)\}').allMatches(value)) m.group(1)!,
  };
  if (names.isEmpty) return '';
  return names.map((n) => '{$n}').join(' ');
}
