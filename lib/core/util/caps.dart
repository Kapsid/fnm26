/// [text] in capitals, the way [languageCode] writes capitals.
///
/// Plain `toUpperCase` is right for every language the app spoke before
/// Turkish and Greek, and is still what they get: this helper returns exactly
/// that for them, so a label set in caps reads the same as it always did.
///
/// Two languages need more than Unicode's default mapping:
///
/// - Turkish (and Azerbaijani) have two i's. Dotted `i` raises to dotted `İ`
///   and dotless `ı` to `I`; the default mapping sends `i` to `I`, which in
///   Turkish is a different letter (`İSTANBUL`, never `ISTANBUL`).
/// - Greek drops the accent from a word set entirely in capitals: `Τετάρτη`
///   is `ΤΕΤΑΡΤΗ`, not `ΤΕΤΆΡΤΗ`. The tonos is stripped; a dialytika that
///   carried a tonos keeps its dialytika (`ΐ` → `Ϊ`).
String capsFor(String text, String languageCode) {
  switch (languageCode) {
    case 'tr':
    case 'az':
      return text.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
    case 'el':
      final buffer = StringBuffer();
      for (final rune in text.runes) {
        final char = String.fromCharCode(rune);
        buffer.write(_greekUnaccented[char] ?? char);
      }
      return buffer.toString().toUpperCase()
      // A decomposed tonos (combining acute) goes the same way.
      .replaceAll('́', '');
    default:
      return text.toUpperCase();
  }
}

/// Each accented Greek vowel, lower and upper case, without its tonos.
const Map<String, String> _greekUnaccented = {
  'ά': 'α',
  'έ': 'ε',
  'ή': 'η',
  'ί': 'ι',
  'ό': 'ο',
  'ύ': 'υ',
  'ώ': 'ω',
  'ΐ': 'ϊ',
  'ΰ': 'ϋ',
  'Ά': 'Α',
  'Έ': 'Ε',
  'Ή': 'Η',
  'Ί': 'Ι',
  'Ό': 'Ο',
  'Ύ': 'Υ',
  'Ώ': 'Ω',
};

/// [capsFor] as a method, so a label already written `text.toUpperCase()`
/// changes in place: `text.capsIn(l.localeName)`.
extension LocaleCaps on String {
  /// This string in capitals, the way [languageCode] writes them.
  String capsIn(String languageCode) => capsFor(this, languageCode);
}
