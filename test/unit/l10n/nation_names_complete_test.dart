import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/nation/nation_names.dart';
import 'package:fnm/domain/services/nation/nation_names_de.dart';
import 'package:fnm/domain/services/nation/nation_names_el.dart';
import 'package:fnm/domain/services/nation/nation_names_es.dart';
import 'package:fnm/domain/services/nation/nation_names_fr.dart';
import 'package:fnm/domain/services/nation/nation_names_id.dart';
import 'package:fnm/domain/services/nation/nation_names_it.dart';
import 'package:fnm/domain/services/nation/nation_names_nl.dart';
import 'package:fnm/domain/services/nation/nation_names_pl.dart';
import 'package:fnm/domain/services/nation/nation_names_pt.dart';
import 'package:fnm/domain/services/nation/nation_names_tr.dart';
import 'package:fnm/domain/services/nation/nation_names_sv.dart';
import 'package:fnm/domain/services/nation/nation_names_nb.dart';
import 'package:fnm/domain/services/nation/nation_names_vi.dart';
import 'package:fnm/domain/services/nation/nation_names_bg.dart';
import 'package:fnm/domain/services/nation/nation_names_da.dart';
import 'package:fnm/domain/services/nation/nation_names_fi.dart';
import 'package:fnm/domain/services/nation/nation_names_hu.dart';
import 'package:fnm/domain/services/nation/nation_names_hr.dart';
import 'package:fnm/domain/services/nation/nation_names_uk.dart';
import 'package:fnm/domain/services/nation/nation_names_fil.dart';

/// Every language's table names every nation in the seed.
///
/// A code missing from a table falls back to the English name silently, so a
/// Turkish list with one English country in it is the failure this catches:
/// nothing crashes, it just reads wrong.
void main() {
  final codes = [
    for (final n
        in jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List<dynamic>)
      (n as Map<String, dynamic>)['code'] as String,
  ];

  final tables = <String, Map<String, String>>{
    'cs': NationNames.csByCode,
    'fr': nationNamesFr,
    'it': nationNamesIt,
    'pl': nationNamesPl,
    'es': nationNamesEs,
    'de': nationNamesDe,
    'pt': nationNamesPt,
    'tr': nationNamesTr,
    'nl': nationNamesNl,
    'id': nationNamesId,
    'el': nationNamesEl,
    'sv': nationNamesSv,
    'nb': nationNamesNb,
    'vi': nationNamesVi,
    'bg': nationNamesBg,
    'da': nationNamesDa,
    'fi': nationNamesFi,
    'hu': nationNamesHu,
    'hr': nationNamesHr,
    'uk': nationNamesUk,
    'fil': nationNamesFil,
  };

  for (final MapEntry(key: language, value: table) in tables.entries) {
    test('$language names every nation in the seed', () {
      final missing = [
        for (final code in codes)
          if ((table[code] ?? '').trim().isEmpty) code,
      ];
      expect(missing, isEmpty, reason: '$language has no name for these');
    });

    test('$language is what display() reads', () {
      for (final code in codes) {
        expect(
          NationNames.display(code, 'seed', language),
          table[code],
          reason: '$language $code',
        );
      }
    });
  }
}
