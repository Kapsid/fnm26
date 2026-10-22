import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The hand-editable copy file (`copy/strings.csv`, via `tool/export_copy.dart`
/// and `tool/import_copy.dart`) is line-based, and it only works while two
/// things stay true of the strings themselves. Both are properties of the ARB
/// files rather than of the tools, so they are checked here — a string added
/// months from now that breaks one of them would otherwise be found by a
/// translator staring at a mangled spreadsheet.
void main() {
  Map<String, Object?> arb(String path) =>
      jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

  final en = arb('lib/l10n/app_en.arb');
  // Every non-English language whose ARB exists.
  final others = <String, Map<String, Object?>>{
    for (final code in [
      'cs',
      'fr',
      'it',
      'pl',
      'es',
      'de',
      'pt',
      'tr',
      'nl',
      'id',
      'el',
      'sv',
      'nb',
      'vi',
      'bg',
      'da',
      'fi',
      'hu',
      'hr',
      'uk',
      'fil',
    ])
      if (File('lib/l10n/app_$code.arb').existsSync())
        code: arb('lib/l10n/app_$code.arb'),
  };

  Iterable<MapEntry<String, String>> strings(Map<String, Object?> m) sync* {
    for (final e in m.entries) {
      if (e.key.startsWith('@')) continue;
      if (e.value is String) yield MapEntry(e.key, e.value! as String);
    }
  }

  test('no string contains a tab, which a row cannot carry', () {
    // Commas and quotes are quoted properly, so a sentence may hold either.
    // A tab cannot be: the importer also accepts tab-separated files, and a
    // string containing one would split a row in a file exported that way.
    for (final (name, file) in [
      ('English', en),
      ...others.entries.map((e) => (e.key, e.value)),
    ]) {
      for (final e in strings(file)) {
        expect(
          e.value.contains('\t'),
          isFalse,
          reason:
              '$name "${e.key}" contains a tab, which would split its row in a '
              'tab-separated copy file — use a space, or a real line break.',
        );
      }
    }
  });

  test('every translation carries the same placeholders as its English', () {
    // The importer refuses a translation that has lost a placeholder, because
    // a string with nowhere to put the value it is passed throws when the
    // screen it is on opens. This checks what is already committed.
    Set<String> holders(String v) => {
      for (final m in RegExp(r'\{(\w+)\}').allMatches(v)) m.group(1)!,
    };
    bool isPlural(String v) =>
        RegExp(r'\{\s*\w+\s*,\s*(plural|select)').hasMatch(v);
    String? variable(String v) =>
        RegExp(r'\{\s*(\w+)\s*,\s*(plural|select)').firstMatch(v)?.group(1);

    for (final lang in others.entries) {
      for (final e in strings(en)) {
        final translated = lang.value[e.key];
        if (translated is! String || translated.trim().isEmpty) continue;
        // A plural's braces are branch machinery, and languages differ in
        // their branches (Polish has few and many) — so only the variable
        // and the mandatory other{ branch are comparable.
        // A language may add a plural the English lacks (Bulgarian, Croatian)
        // or drop one it has (Vietnamese): then the values used must match.
        if (isPlural(e.value) != isPlural(translated)) {
          Set<String> all(String v) => {
            ...holders(v),
            for (final m in RegExp(
              r'\{\s*(\w+)\s*,\s*(?:plural|select)',
            ).allMatches(v))
              m.group(1)!,
          };
          expect(
            all(translated),
            all(e.value),
            reason: '${lang.key} "${e.key}" reshapes its plural but does not '
                'use the same values as the English',
          );
          continue;
        }
        if (isPlural(e.value)) {
          expect(
            isPlural(translated) &&
                variable(translated) == variable(e.value) &&
                RegExp(r'\bother\s*\{').hasMatch(translated),
            isTrue,
            reason:
                '${lang.key} "${e.key}" has lost its {count, plural, …} '
                'skeleton, variable or other{} branch',
          );
          continue;
        }
        expect(
          holders(translated),
          holders(e.value),
          reason:
              '${lang.key} "${e.key}" does not use the same placeholders as '
              'the English it translates',
        );
      }
    }
  });
}
