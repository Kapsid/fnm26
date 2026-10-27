import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The qualification achievements are about getting INTO a tournament, and
/// must say so in words that cannot be mistaken for the board's "Reach the
/// final".
///
/// They read "Reach the World Championship finals" ("Postupte na závěrečný
/// turnaj mistrovství světa"), an order in the board's own voice, popping up
/// in the middle of a World Championship whose brief was "Reach the final"
/// ("Postoupit do finále"). A manager read it as the board telling him his
/// target was the finals tournament. They are now worded as the board's own
/// qualify brief is: "Qualify for the World Championship".
void main() {
  const locales = [
    'en',
    'cs',
    'de',
    'es',
    'fr',
    'it',
    'pl',
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
    'hi',
    'ja',
    'ko',
    'ro',
    'th',
    'ms',
  ];
  const keys = ['achQualWcDesc', 'achQualContDesc'];
  // Every locale's word for a final, a finals stage or a final tournament.
  final finalWords = RegExp(
    'final|finál|finał|závěrečn|endrunde|eindtoernooi|eindronde|τελικ|финал|фінал|chung kết|finaali|loppukilpailu|döntő|završni|huling|pangwakas|finále|फ़ाइनल|फाइनल|決勝|本大会|본선|결승|รอบสุดท้าย|ชิงชนะเลิศ',
    caseSensitive: false,
  );

  for (final locale in locales) {
    test('$locale: the qualifier achievements never speak of a final', () {
      final arb =
          jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
              as Map<String, dynamic>;
      for (final key in keys) {
        final text = arb[key] as String?;
        expect(text, isNotNull, reason: '$locale has $key');
        expect(
          finalWords.hasMatch(text!),
          isFalse,
          reason: '$locale $key reads like a "reach the final" brief: $text',
        );
      }
    });
  }
}
