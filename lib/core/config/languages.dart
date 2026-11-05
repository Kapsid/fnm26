/// The app's language codes, as plain constants: no Flutter, no Riverpod,
/// so the domain (a world pack's per-language names) can read them.
/// `ui_language.dart` re-exports them.
library;

/// The languages the app speaks. Anything else is drawn in English.
const List<String> supportedLanguageCodes = [
  'en',
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
  'hi',
  'ja',
  'ko',
  'ro',
  'th',
  'ms',
];
