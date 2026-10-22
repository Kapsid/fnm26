import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards `country_names_more.json`, the extra names a career created from
/// 1.0.6 on draws from (see `namePoolsV2Kind`).
///
/// The extras are additions only: a name already in `country_names.json` would
/// just make two spellings of one pool, and a famous international's surname
/// would put a real star in a fictional squad.
void main() {
  final base =
      jsonDecode(File('assets/data/country_names.json').readAsStringSync())
          as Map<String, dynamic>;
  final more =
      jsonDecode(File('assets/data/country_names_more.json').readAsStringSync())
          as Map<String, dynamic>;
  final codeById = {
    for (final n
        in jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List<dynamic>)
      '${(n as Map)['id']}': (n['code'] as String).toUpperCase(),
  };

  List<String> list(Map<String, dynamic> m, String nation, String key) =>
      (((m[nation] as Map?)?[key] as List?) ?? const []).cast<String>();

  test('every list is new, unique and free of famous internationals', () {
    expect(more, isNotEmpty);
    for (final nation in more.keys) {
      expect(
        base.containsKey(nation),
        isTrue,
        reason: 'unknown nation $nation',
      );
      final firstMore = list(more, nation, 'firstMore');
      final surMore = list(more, nation, 'surMore');
      for (final (name, extra) in [
        ('firstMore', firstMore),
        ('surMore', surMore),
      ]) {
        expect(
          extra.toSet(),
          hasLength(extra.length),
          reason: '$nation $name has duplicates',
        );
        for (final n in extra) {
          expect(n.trim(), isNotEmpty, reason: '$nation $name has a blank');
          expect(n, n.trim(), reason: '$nation $name "$n" is padded');
        }
      }
      final firstBase = list(base, nation, 'first').toSet();
      final surBase = {
        ...list(base, nation, 'sur'),
        ...list(base, nation, 'surLate'),
      };
      expect(
        firstMore.where(firstBase.contains),
        isEmpty,
        reason: '$nation firstMore repeats the base list',
      );
      expect(
        surMore.where(surBase.contains),
        isEmpty,
        reason: '$nation surMore repeats the base list',
      );

      final banned = {
        for (final s in _famous[codeById[nation]] ?? const <String>[])
          s.toLowerCase(),
      };
      final hits = [
        for (final n in [...firstMore, ...surMore])
          if (banned.contains(n.toLowerCase())) n,
      ];
      expect(
        hits,
        isEmpty,
        reason: '${codeById[nation]} carries a famous international',
      );
    }
  });

  test(
    'every nation is covered, with at least a hundred of each',
    () {
      for (final nation in base.keys) {
        expect(
          more.containsKey(nation),
          isTrue,
          reason: '${codeById[nation]} ($nation) has no extra names',
        );
        final first =
            list(base, nation, 'first').length +
            list(more, nation, 'firstMore').length;
        final sur =
            list(base, nation, 'sur').length +
            list(base, nation, 'surLate').length +
            list(more, nation, 'surMore').length;
        expect(
          first,
          greaterThanOrEqualTo(100),
          reason: '${codeById[nation]} first names',
        );
        expect(
          sur,
          greaterThanOrEqualTo(100),
          reason: '${codeById[nation]} surnames',
        );
      }
    },
  );
}

/// Surnames (and one-name stage names) of famous real internationals, by FIFA
/// code. Common names a famous player happens to share are left out on
/// purpose (Müller, Silva, Fernandes, Suárez): those belong in a pool.
const Map<String, List<String>> _famous = {
  'ARG': ['Messi', 'Maradona', 'Agüero', 'Aguero', 'Di María', 'Batistuta'],
  'POR': ['Ronaldo', 'Eusébio', 'Eusebio', 'Figo'],
  'FRA': ['Mbappé', 'Mbappe', 'Griezmann', 'Zidane', 'Benzema', 'Platini'],
  'NOR': ['Haaland', 'Ødegaard', 'Odegaard'],
  'POL': ['Lewandowski', 'Szczęsny', 'Szczesny'],
  'CRO': ['Modrić', 'Modric', 'Šuker', 'Suker'],
  'EGY': ['Salah'],
  'BRA': [
    'Neymar',
    'Ronaldinho',
    'Kaká',
    'Kaka',
    'Pelé',
    'Pele',
    'Romário',
    'Coutinho',
  ],
  'ENG': ['Kane', 'Bellingham', 'Beckham', 'Rooney', 'Gerrard', 'Lineker'],
  'KOR': ['Son'],
  'USA': ['Pulisic'],
  'BIH': ['Džeko', 'Dzeko', 'Pjanić', 'Pjanic'],
  'BEL': ['Hazard', 'De Bruyne', 'Lukaku', 'Courtois'],
  'GER': ['Kroos', 'Neuer', 'Musiala', 'Beckenbauer', 'Klose'],
  'NED': ['Cruyff', 'Van Dijk', 'Robben', 'Van Persie'],
  'ESP': ['Iniesta', 'Casillas', 'Pedri'],
  'ITA': ['Buffon', 'Totti', 'Pirlo', 'Maldini'],
  'SWE': ['Ibrahimović', 'Ibrahimovic'],
  'WAL': ['Bale'],
  'SEN': ['Mané', 'Mane'],
  'NGA': ['Osimhen', 'Okocha'],
  'CMR': ["Eto'o", 'Etoo'],
  'URU': ['Forlán', 'Forlan', 'Cavani'],
  'CIV': ['Drogba'],
  'GHA': ['Essien'],
  'JPN': ['Mitoma', 'Kubo'],
  'CZE': ['Nedvěd', 'Nedved', 'Čech', 'Cech', 'Schick'],
  'SVK': ['Hamšík', 'Hamsik', 'Škriniar', 'Skriniar'],
  'SRB': ['Vlahović', 'Vlahovic'],
  'GEO': ['Kvaratskhelia'],
};
