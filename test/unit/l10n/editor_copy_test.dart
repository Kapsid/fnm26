import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The database editor's copy is in every language.
///
/// Every editor key (and the few keys the editor added elsewhere) exists in
/// all 28 ARBs with a non-empty value. Some strings are rightly the same as
/// the English ("Editor", "GK", a Filipino loanword), so instead of banning
/// that, a language may match the English on at most a fifth of them: more
/// than that means a column was left untranslated.
void main() {
  final dir = Directory('lib/l10n');
  Map<String, dynamic> arb(String code) =>
      jsonDecode(File('${dir.path}/app_$code.arb').readAsStringSync())
          as Map<String, dynamic>;

  final en = arb('en');
  const extra = {
    'homeEditor',
    'settingsDefaultWorldTitle',
    'settingsDefaultWorldBlurb',
    'worldPackNotReady',
  };
  final keys = [
    for (final k in en.keys)
      if (!k.startsWith('@') && (k.startsWith('editor') || extra.contains(k)))
        k,
  ];
  final codes = [
    for (final f in dir.listSync())
      if (f.path.endsWith('.arb'))
        f.uri.pathSegments.last.replaceAll('app_', '').replaceAll('.arb', ''),
  ]..remove('en');

  test('there are 28 languages and the editor has copy', () {
    expect(codes.length + 1, 28);
    expect(keys.length, greaterThan(150));
  });

  for (final code in codes) {
    test('$code has every editor string, translated', () {
      final t = arb(code);
      final missing = [
        for (final k in keys)
          if ((t[k] as String?)?.trim().isEmpty ?? true) k,
      ];
      expect(missing, isEmpty, reason: '$code is missing $missing');
      final same = [
        for (final k in keys)
          if (t[k] == en[k]) k,
      ];
      expect(
        same.length,
        lessThanOrEqualTo(keys.length ~/ 5),
        reason: '$code matches the English on $same',
      );
    });
  }
}
