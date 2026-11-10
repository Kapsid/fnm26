import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The two strings the profanity filter shows: in every language the game
/// speaks, translated (not the English left in), with the name placeholder
/// kept, no em dash, and French setting off its colon with a no-break space.
void main() {
  const keys = ['editorNameNotAllowed', 'editorIssueNameNotAllowed'];
  final arbs = {
    for (final f in Directory('lib/l10n').listSync())
      if (f is File && f.path.endsWith('.arb'))
        f.path.split('app_').last.split('.').first:
            jsonDecode(f.readAsStringSync()) as Map<String, Object?>,
  };

  test('all 28 languages have both strings', () {
    expect(arbs.length, 28);
    for (final MapEntry(key: lang, value: arb) in arbs.entries) {
      for (final k in keys) {
        final v = arb[k];
        expect(v, isA<String>(), reason: '$lang $k');
        expect((v! as String).trim(), isNotEmpty, reason: '$lang $k');
        expect(v as String, isNot(contains('—')), reason: '$lang $k');
        if (lang != 'en') {
          expect(v, isNot(arbs['en']![k]), reason: '$lang $k is English');
        }
      }
      expect(
        arb['editorIssueNameNotAllowed']! as String,
        contains('{name}'),
        reason: lang,
      );
    }
  });

  test('Czech says it in Czech', () {
    expect(arbs['cs']!['editorNameNotAllowed'], 'Tento název není povolený.');
    expect(
      arbs['cs']!['editorIssueNameNotAllowed'],
      '„{name}“ není povolený název',
    );
  });

  test('French quotes and colons take a no-break space', () {
    for (final k in keys) {
      final v = arbs['fr']![k]! as String;
      expect(RegExp(r'[^ ]:').hasMatch(v), isFalse, reason: k);
      if (v.contains('«')) expect(v, contains('« {name} »'), reason: k);
    }
  });
}
