import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The two copy rules every language follows, held for the five that came
/// last: Portuguese, Turkish, Dutch, Indonesian, Greek, Swedish, Norwegian,
/// Vietnamese, Bulgarian, Danish, Finnish, Hungarian, Croatian, Ukrainian and
/// Filipino.
///
/// The tournament is the World Championship in every language, never the
/// local name of the real one (the app has no licence for it). Each language
/// has its own everyday phrase, and a translator reaching for the familiar one
/// is the likeliest slip, so each is listed by name. And no em dash appears in
/// player-facing copy, in any language.
void main() {
  const banned = <String, List<String>>{
    'pt': ['Copa do Mundo'],
    'tr': ['Dünya Kupası'],
    'nl': ['Wereldbeker', 'WK-beker'],
    'id': ['Piala Dunia'],
    'el': ['Παγκόσμιο Κύπελλο'],
    'sv': ['världscup', 'VM-cup'],
    'nb': ['verdenscup'],
    'vi': ['Cúp thế giới'],
    'bg': ['Световна купа', 'Мондиал'],
    'da': ['verdenscup'],
    'fi': ['maailmancup'],
    'hu': ['világkupa'],
    'hr': ['Svjetski kup'],
    'uk': ['Кубок світу', 'мундіаль'],
    'fil': ['Pandaigdigang Kopa'],
  };

  // Every phrase is checked in every new language: a Dutch translator quoting
  // the Portuguese name is still the slip.
  final phrases = [
    for (final list in banned.values) ...list,
    'world cup',
  ];

  for (final code in banned.keys) {
    final arb =
        jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync())
            as Map<String, dynamic>;
    final strings = {
      for (final e in arb.entries)
        if (!e.key.startsWith('@') && e.value is String)
          e.key: e.value as String,
    };

    test('$code never names the real World Cup', () {
      final offenders = [
        for (final e in strings.entries)
          for (final phrase in phrases)
            if (e.value.toLowerCase().contains(phrase.toLowerCase()))
              '${e.key}: "${e.value}"',
      ];
      expect(offenders, isEmpty, reason: offenders.join('\n'));
    });

    test('$code carries no em dash', () {
      final offenders = [
        for (final e in strings.entries)
          if (e.value.contains('—')) '${e.key}: "${e.value}"',
      ];
      expect(offenders, isEmpty, reason: offenders.join('\n'));
    });
  }
}
