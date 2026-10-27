import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The two copy rules every language follows, held for the five that came
/// last: Portuguese, Turkish, Dutch, Indonesian, Greek, Swedish, Norwegian,
/// Vietnamese, Bulgarian, Danish, Finnish, Hungarian, Croatian, Ukrainian,
/// Filipino, Hindi, Japanese, Korean, Romanian, Thai and Malay.
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
    'hi': ['विश्व कप', 'वर्ल्ड कप', 'विश्वकप'],
    'ja': ['ワールドカップ', 'W杯'],
    'ko': ['월드컵'],
    'ro': ['Cupa Mondială', 'Cupa Mondiala'],
    'th': ['ฟุตบอลโลก', 'เวิลด์คัพ'],
    'ms': ['Piala Dunia'],
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

  // The first languages, each checked against its OWN everyday names only:
  // "mundial" is a plain adjective in Spanish ("ranking mundial") while it is
  // the real tournament's nickname in Polish, so these phrases cannot be
  // crossed between languages the way the list above is. The literal
  // abbreviations of "World Championship" (de WM, pl MŚ, cs MS, nl WK) are
  // the app's own name and stay allowed.
  const ownNames = <String, List<String>>{
    'en': ['world cup'],
    'cs': ['Světový pohár', 'mundiál'],
    'de': ['Weltpokal', 'WM-Pokal', 'Weltcup'],
    'es': ['Copa del Mundo', 'Copa Mundial', 'mundialista'],
    'fr': ['Coupe du monde'],
    'it': [
      'Coppa del Mondo',
      'i Mondiali',
      'ai Mondiali',
      'dei Mondiali',
      'nei Mondiali',
      'il Mondiale',
      'al Mondiale',
      'del Mondiale',
    ],
    'pl': ['Puchar Świata', 'mundial'],
    'pt': ['Copa do Mundo', 'mundialista'],
  };

  // Spanish and Portuguese: "el Mundial", "o Mundial", "do Mundial" is the
  // real World Cup. A capitalised "Mundial" (or the plural) is the noun unless
  // it follows "Campeonato" (or "Campeão", a world champion); in ALL CAPS
  // the noun is the one after an article or preposition, or one that opens
  // the string. The adjective ("ranking mundial", "RANKING MUNDIAL",
  // "Campeonato Mundial") passes.
  final mundialNoun = RegExp(
    r'(?<!(Campeonatos?|Campe[ãa]o|Campeã|Campeões|Campeãs|Campeon[ae]s?) )'
    r'\bMundial(es)?\b',
  );
  // Letters, not `\b`, mark the word edges: `\b` knows only ASCII, so it
  // would read the "O" that ends "CAMPEÃO" as a word of its own.
  final mundialNounCaps = RegExp(
    r'(^|(?<!\p{L})(EL|DEL|AL|EN|LOS|DE|PARA|O|DO|AO|NO|OS|DOS|NOS)\s+)'
    r'MUNDIAL(ES)?(?!\p{L})',
    unicode: true,
  );

  for (final code in ownNames.keys) {
    final arb =
        jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync())
            as Map<String, dynamic>;
    final strings = {
      for (final e in arb.entries)
        if (!e.key.startsWith('@') && e.value is String)
          e.key: e.value as String,
    };

    test('$code never names the real World Cup by its local name', () {
      final offenders = [
        for (final e in strings.entries)
          for (final phrase in ownNames[code]!)
            if (e.value.toLowerCase().contains(phrase.toLowerCase()))
              '${e.key}: "${e.value}"',
        if (code == 'es' || code == 'pt')
          for (final e in strings.entries)
            if (mundialNoun.hasMatch(e.value) ||
                mundialNounCaps.hasMatch(e.value))
              '${e.key}: "${e.value}"',
      ];
      expect(offenders, isEmpty, reason: offenders.join('\n'));
    });
  }

  test('the Mundial guard tells the noun from the adjective', () {
    bool flags(String s) =>
        mundialNoun.hasMatch(s) || mundialNounCaps.hasMatch(s);
    for (final noun in [
      'Clasificado para el Mundial',
      'Artilheiro do Mundial',
      'MAIS TITULARIDADES NO MUNDIAL',
      'MÁS PARTIDOS EN MUNDIALES',
      'MUNDIAL #{rank}',
      'Clas. Mundial',
    ]) {
      expect(flags(noun), isTrue, reason: noun);
    }
    for (final fine in [
      'Ranking mundial',
      'RANKING MUNDIAL',
      'Campeonato Mundial',
      'CAMPEONATO MUNDIAL',
      'NO CAMPEONATO MUNDIAL',
      'Campeão Mundial',
      'CAMPEÃO MUNDIAL {year}',
      'SORTEO DE CLASIFICACIÓN MUNDIAL',
    ]) {
      expect(flags(fine), isFalse, reason: fine);
    }
  });
}
