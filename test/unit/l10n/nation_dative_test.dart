import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/nation_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/nation/nation_names.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// Czech declines and the app did not.
///
/// "Hrát proti Litva" was what a Czech player read on his next-match button:
/// the nominative wearing a preposition, which is not a sentence in Czech.
/// "Proti" governs the dative, so the button has to say "proti Litvě" — and
/// a second column of names is the only way to get there, because no rule
/// derives the dative from the nominative reliably enough to trust.
///
/// These are the guards on that column. The first two are the ones that
/// matter: a nation with no dative at all falls back to the nominative
/// silently, and a dative left equal to its nominative by a copy-paste is
/// exactly the bug being fixed, wearing the fix's clothes.
void main() {
  test('every nation with a Czech name has a Czech dative', () {
    final missing = NationNames.csByCode.keys
        .where((c) => !NationNames.csDativeByCode.containsKey(c))
        .toList();
    expect(
      missing,
      isEmpty,
      reason:
          'these nations have a Czech name but no dative, so every sentence '
          'that puts them after "proti" falls back to the nominative: '
          '${missing.join(', ')}',
    );
  });

  test('no dative is left equal to its nominative by accident', () {
    // The declinable ones. An entry that matches its nominative here was
    // pasted and not translated — which reads exactly like the bug.
    final unchanged = <String>[];
    for (final entry in NationNames.csByCode.entries) {
      if (NationNames.csIndeclinable.contains(entry.key)) continue;
      if (NationNames.csDativeByCode[entry.key] == entry.value) {
        unchanged.add('${entry.key} (${entry.value})');
      }
    }
    expect(
      unchanged,
      isEmpty,
      reason:
          'these datives are identical to the nominative: '
          '${unchanged.join(', ')}. If the name genuinely does not decline, '
          'name it in NationNames.csIndeclinable and say why.',
    );
  });

  test('every name declared indeclinable really is left alone', () {
    // The other direction: the exemption list must not grow stale, or it
    // quietly exempts a name somebody later declined properly.
    for (final code in NationNames.csIndeclinable) {
      expect(
        NationNames.csByCode,
        contains(code),
        reason: '$code is exempted from declining but has no Czech name',
      );
      expect(
        NationNames.csDativeByCode[code],
        NationNames.csByCode[code],
        reason:
            '$code is listed as indeclinable but its dative differs from its '
            'nominative. Take it off the list.',
      );
    }
  });

  test('the dative table covers exactly the nations the app ships', () {
    // The seed is the source of truth for which nations exist at all; a
    // dative for a code that is not one of them is dead weight, and the
    // seed gaining a nation must fail here rather than in Czech.
    final seed = File('assets/data/nations.json').readAsStringSync();
    final codes = RegExp(r'"code"\s*:\s*"([A-Z]{3})"')
        .allMatches(seed)
        .map((m) => m.group(1)!)
        .toSet();
    expect(codes, isNotEmpty);
    final uncovered = codes
        .where((c) => !NationNames.csDativeByCode.containsKey(c))
        .toList();
    expect(
      uncovered,
      isEmpty,
      reason: 'seeded nations with no Czech dative: ${uncovered.join(', ')}',
    );
  });

  group('the form the sentence actually gets', () {
    Nation nation(String code, String name) => Nation(
      id: 1,
      name: name,
      code: code,
      confederation: Confederation.europe,
      ranking: 1,
    );

    test('Czech takes the dative, and the button reads as Czech', () {
      final l = AppLocalizationsCs();
      expect(nationAgainst(l, nation('LTU', 'Litva'), '?'), 'Litvě');
      expect(
        l.hubEventPlayOpponent(nationAgainst(l, nation('LTU', 'Litva'), '?')),
        'Hrát proti Litvě',
      );
      // The three other shapes the brief named, one of each kind: a neuter
      // in -sko, a feminine in -ie, and a plural that takes -ům.
      expect(nationAgainst(l, nation('GER', 'Německo'), '?'), 'Německu');
      expect(nationAgainst(l, nation('ENG', 'Anglie'), '?'), 'Anglii');
      expect(
        nationAgainst(l, nation('UAE', 'Spojené arabské emiráty'), '?'),
        'Spojeným arabským emirátům',
      );
    });

    test('English is untouched: it has no cases', () {
      final l = AppLocalizationsEn();
      expect(nationAgainst(l, nation('LTU', 'Lithuania'), '?'), 'Lithuania');
      expect(
        l.hubEventPlayOpponent(
          nationAgainst(l, nation('LTU', 'Lithuania'), '?'),
        ),
        'Play Lithuania',
      );
    });

    test('a nation the table never learnt keeps the name it came with', () {
      final l = AppLocalizationsCs();
      expect(nationAgainst(l, nation('ZZZ', 'Atlantida'), '?'), 'Atlantida');
      expect(nationAgainst(l, null, 'Unknown'), 'Unknown');
    });
  });

  test('the next-match button is fed the dative, not the plain name', () {
    // The table is no use unwired, and the wiring is one argument on one
    // line: `opp(oppId)` prints the nominative and reads as the bug. A
    // source check because the label is decided inside a closure in a
    // provider, where only a whole seeded career could reach it.
    final source = File('lib/features/hub/hub_event.dart').readAsStringSync();
    expect(
      source,
      contains('l.hubEventPlayOpponent(oppAgainst('),
      reason:
          'the next-match button must name its opponent through '
          'nationAgainst, or Czech reads "Hrát proti Litva" again',
    );
    expect(source, isNot(contains('l.hubEventPlayOpponent(opp(')));
  });
}
