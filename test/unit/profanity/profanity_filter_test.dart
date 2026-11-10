import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/profanity/profanity_filter.dart';
import 'package:fnm/domain/services/profanity/profanity_words.dart';

void main() {
  group('refuses', () {
    // Per language: plain, inflected, and the evasions a player would try.
    const offensive = {
      'en': [
        'fuck',
        'Fuck United',
        'motherfucker',
        'FUCKING',
        'f.u.c.k',
        'f u c k',
        'fuuuuck',
        'f*u*c*k',
        'fück',
        'bitch',
        'b i t c h',
        'Bitches FC',
        'b1tch',
        'b!tch',
        'wh0r3',
        'whore',
        'wh0re',
        'whores',
        'cunt',
        'c-u-n-t',
        'shit',
        'sh1t',
        '5hit',
        'shitty',
        'bullshit',
        'asshole',
        r'a$$',
        'ass',

        'nigger',
        'n1gger',
        'faggot',

        'dickhead',
        'cock',
        'pussy',
        'wanker',
        'twat',
      ],
      'cs': [
        'kurva',
        'Kurvo',
        'zkurvysyn',
        'píča',
        'píčo',
        'píčus',
        'čurák',
        'curak',
        'kokot',
        'kokote',
        'zmrd',
        'hovno',
        'šukat',
        'buzerant',
        'prdel',
        'děvka',
        'k.u.r.v.a',
      ],
      'sk': ['piča', 'pička', 'jebať', 'skurvysyn'],
      'pl': [
        'kurwa',
        'kurwy',
        'kurwą',
        'skurwiel',
        'chuj',
        'chujowy',
        'pierdolić',
        'spierdalaj',
        'jebany',
        'zajebisty',
        'dziwka',
        'pedał',
        'pizda',
      ],
      'de': [
        'Fotze',
        'Hure',
        'Hurensohn',
        'Wichser',
        'Arschloch',
        'Scheiße',
        'scheisse',
        'Schlampe',
        'ficken',
        'Schwuchtel',
      ],
      'fr': [
        'putain',
        'pute',
        'salope',
        'connard',
        'enculé',
        'merde',
        'pédé',
        'bâtard',
        'nègre',
      ],
      'es': [
        'puta',
        'puto',
        'coño',
        'cabrón',
        'gilipollas',
        'joder',
        'maricón',
        'pendejo',
        'mierda',
        'hijoputa',
      ],
      'pt': [
        'caralho',
        'porra',
        'foda',
        'buceta',
        'viado',
        'merda',
        'arrombado',
        'punheta',
      ],
      'it': [
        'cazzo',
        'vaffanculo',
        'stronzo',
        'puttana',
        'minchia',
        'coglione',
        'frocio',
      ],
      'nl': ['klootzak', 'hoer', 'neuken', 'kankerlijer', 'flikker'],
      'hr': ['kurac', 'pička', 'jebem', 'jebote', 'jebiga', 'govno'],
      'hu': ['geci', 'fasz', 'faszfej', 'picsa', 'baszd meg', 'bazdmeg'],
      'ro': ['pulă', 'muie', 'futui', 'pizda'],
      'sv': ['fitta', 'knulla', 'jävla', 'horunge'],
      'fi': ['vittu', 'paska', 'huora', 'kyrpä', 'mulkku'],
      'tr': ['orospu', 'siktir', 'yarrak', 'amına', 'ibne', 'piç'],
      'ru': ['хуй', 'пиздец', 'блядь', 'сука', 'blyat', 'pidor'],
      'el': ['μαλάκα', 'πουτάνα'],
      'id': ['kontol', 'ngentot', 'memek'],
      'fil': ['putangina', 'putang ina'],
      'hi': ['chutiya', 'madarchod', 'bhenchod'],
      'ko': ['씨발'],
    };
    for (final MapEntry(key: language, value: words) in offensive.entries) {
      test(language, () {
        final passed = [
          for (final w in words)
            if (w.isNotEmpty && ProfanityFilter.isClean(w)) w,
        ];
        expect(passed, isEmpty, reason: 'let through');
      });
    }
  });

  group('allows', () {
    test('every name on the allowlist, and the classic traps', () {
      const names = [
        'Scunthorpe United',
        'Essex',
        'Sussex',
        'Middlesex',
        'Penistone',
        'Cockburn',
        'Dickson',
        'Hitchcock',
        'Hancock',
        'Shitara',
        'Bitche',
        'Analyst',
        'Assessment',
        'Antonio Cassano',
        'Daniel Passarella',
        'Titov',
        'Stefan Kuntz',
        'Fagerström',
        'Faggio',
        'Arsenal',
        'Cumbria',
        'Clitheroe',
        'Wankdorf',
        'Wankdorfstadion',
        'Dikmen',
        'Pikachu',
        'Kurtz',
        'Porras',
        'Picasso',
        'špička',
        'Pula',
        'Yamashita',
        'Kinoshita',
        'Fukuda',
        'Fodé',
        'Fittipaldi',
        'Vittorio',
        'Paskal',
        'Amina',
        'Peder',
        'Tite',
        'Suka',
        'AS Roma',
        'A.S. Roma',
        'Real Madrid C.F.',
        'Massimo',
        'Glasgow',
        'Hoeness',
        'Šuker',
        'Mrđa',
        'Slutsky',
        'Hurel',
        'Advocaat',
        'Kocsis',
        'Fickling',
        'Basque',
        'Baszkír',
        'Coney',
        'Pedal',
        'Pollack',
        'Cona',
        'Conor',
        'Negri',
        'Negru',
        'Marica',
        'Polla',
        'Verga',
        'Shiitake',
        'Matsushita',
        'Assane',
        'Hassan',
        'Cassius',
        'Bassong',
        'Grassi',
        'Kassel',
        'Jeb',
        'Pique',
        'Niko',
        'Faisal',
        'Tito',
        'Titus',
        'Ankara',
        'Analía',
        'Anal',
        'Rapé',
      ];
      final refused = [
        for (final n in names)
          if (ProfanityFilter.isOffensive(n)) n,
      ];
      expect(refused, isEmpty);
      for (final a in profanityAllowlist) {
        final word = a.replaceAll('*', '');
        expect(ProfanityFilter.isClean(word), isTrue, reason: a);
      }
    });

    test('names with digits, initials and punctuation', () {
      for (final n in [
        'Team 1',
        '1. FC Köln',
        'J. R. Smith',
        'A.C. Milan',
        'Hello!',
        'U-21',
        'Player 55',
        '',
        '   ',
        'F.C. Porto',
        'S.S. Lazio',
      ]) {
        expect(ProfanityFilter.isClean(n), isTrue, reason: n);
      }
    });

    // Real names whose one word is refused on its own: allowed only as the
    // whole name, so the word alone still is not.
    test('real names on the allowed-names list, as whole names only', () {
      for (final n in [
        'Jakob Wanker',
        'JAKOB WANKER',
        'Franco Foda',
        'Hang Jebat Stadium',
        'Stadion Hang Jebat',
      ]) {
        expect(ProfanityFilter.isClean(n), isTrue, reason: n);
      }
      for (final n in [
        'Wanker',
        'Wanker United',
        'Foda FC',
        'Jebat',
        'Jakob Wanker Wanker',
      ]) {
        expect(ProfanityFilter.isClean(n), isFalse, reason: n);
      }
      expect(ProfanityFilter.mask('Jakob Wanker Wanker'), 'Jakob Wanker W*****');
    });
  });

  group('mask', () {
    test('keeps the first letter of each refused word', () {
      expect(ProfanityFilter.mask('Fuck United'), 'F*** United');
      expect(ProfanityFilter.mask('Kurva and Píča'), 'K**** and P***');
      expect(ProfanityFilter.mask('f.u.c.k'), 'f.*.*.*');
      expect(ProfanityFilter.mask('Clean Name'), 'Clean Name');
      expect(ProfanityFilter.mask('f u c k off'), 'f * * * off');
      expect(ProfanityFilter.mask('Sh1t FC'), 'S*** FC');
      // A refused single letter inside refused joined letters: one span.
      expect(ProfanityFilter.mask('좆 좆'), '좆 *');
      expect(ProfanityFilter.mask('Scunthorpe'), 'Scunthorpe');
    });

    test('a masked name is clean', () {
      for (final n in ['Fuck United', 'b i t c h', 'kurwa mać', 'sh1t']) {
        expect(ProfanityFilter.isClean(ProfanityFilter.mask(n)), isTrue);
      }
    });
  });

  test('every word list entry refuses its own word', () {
    final passed = <String>[];
    for (final words in profanityWords.values) {
      for (final e in words) {
        final w = e.replaceAll('*', '').replaceAll('=', '');
        if (ProfanityFilter.isClean(w)) passed.add(e);
      }
    }
    expect(passed, isEmpty);
  });

  test('no name the game ships is refused', () {
    final names = shippedNames();
    // The corpus really is the game's: tens of thousands of names.
    expect(names.length, greaterThan(20000));
    final refused = [
      for (final n in names)
        if (ProfanityFilter.isOffensive(n)) n,
    ]..sort();
    expect(refused, isEmpty);
  });

  test('no translated string is refused, but known everyday words', () {
    // A word that is a slur in one language and an everyday word in
    // another: refused in a name, expected in that language's own copy.
    const everyday = {
      // Croatian "puta": times ("deset puta").
      'hr': {'puta'},
    };
    final refused = <String>[];
    for (final f in Directory('lib/l10n').listSync()) {
      if (f is! File || !f.path.endsWith('.arb')) continue;
      final lang = f.path.split('_').last.split('.').first;
      final allowed = everyday[lang] ?? const <String>{};
      final arb = jsonDecode(f.readAsStringSync()) as Map<String, Object?>;
      for (final e in arb.entries) {
        if (e.key.startsWith('@') || e.value is! String) continue;
        final words = (e.value! as String)
            .split(RegExp(r'[\s{}.,;:!?]+'))
            .where((w) => !allowed.contains(w.toLowerCase()))
            .join(' ');
        if (ProfanityFilter.isOffensive(words)) refused.add('$lang ${e.key}');
      }
    }
    expect(refused, isEmpty);
  });
}

/// Every name the game ships: each string in the bundled data (players,
/// name pools, cities, stadiums, nations), the clubs (curated leagues and
/// the sides named for each country's cities), the Y accounts, the press
/// pack.
Set<String> shippedNames() {
  final out = <String>{};
  void walk(Object? v) {
    switch (v) {
      case final String s:
        out.add(s);
      case final List<Object?> l:
        l.forEach(walk);
      case final Map<String, Object?> m:
        m.values.forEach(walk);
    }
  }

  for (final f in Directory('assets/data').listSync()) {
    if (f is File && f.path.endsWith('.json')) {
      walk(jsonDecode(f.readAsStringSync()));
    }
  }
  final cities =
      jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
          as Map<String, Object?>;
  final nations =
      jsonDecode(File('assets/data/nations.json').readAsStringSync())
          as List<Object?>;
  for (final n in nations.cast<Map<String, Object?>>()) {
    final code = (n['code']! as String).toLowerCase();
    final list = (cities['${n['id']}'] as List?)?.cast<String>() ?? const [];
    out.addAll(ClubService.domesticClubNames(code, list));
  }
  for (final l in ClubService.allLeagues()) {
    out.addAll(l.clubs);
  }
  out.addAll(YFeed.namedAccounts);
  for (final r in Press.reporters) {
    out
      ..add(r.name)
      ..add(r.outlet);
  }
  return out;
}
