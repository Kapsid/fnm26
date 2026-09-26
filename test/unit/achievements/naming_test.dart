import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';

/// The trademarked phrase, however it is cased and however it is spaced.
///
/// This guard used to read `contains('World Cup')`, which is case-SENSITIVE,
/// and every heading in this app is ALL CAPS: four strings sat behind that
/// blind spot for months — the ceremony banner, the record book's starts
/// board, and both draw-ceremony headings — because "WORLD CUP" is not
/// "World Cup". A space is required in the pattern so Dart identifiers such as
/// [worldCupHonourName] and provider keys such as `worldCupFinals`, which are
/// never read by a manager, do not trip it.
final _worldCup = RegExp(r'world\s+cup', caseSensitive: false);

Matcher get _saysWorldCup => matches(_worldCup);

/// The competition is the "World Championship" in everything the manager
/// reads. [worldCupHonourName] is the one exception, and only because it is a
/// STORED value: change it and every honour already recorded in a save points
/// at a competition that no longer exists.
void main() {
  test('no achievement says "World Cup"', () {
    for (final a in AchievementCatalog.all) {
      expect(a.title, isNot(_saysWorldCup), reason: a.id);
      expect(a.description, isNot(_saysWorldCup), reason: a.id);
    }
  });

  test('nothing the manager reads, in any language, says "World Cup"', () {
    // Every string in both catalogues, not only the achievements: the phrase
    // is a registered trademark in this exact context, and it leaked back in
    // one screen at a time — the trophy cabinet, the record book's best
    // finish, the heading on a background tournament's popup — each of them a
    // string that was printed raw instead of going through the translator.
    //
    // Every offender is collected before anything is asserted. A per-string
    // `expect` stops at the first one, so a sweep like this one reported one
    // key per run and hid the other three behind it.
    final offenders = <String>[];
    for (final path in ['lib/l10n/app_en.arb', 'lib/l10n/app_cs.arb']) {
      final arb =
          jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      for (final entry in arb.entries) {
        final value = entry.value;
        if (value is String && _worldCup.hasMatch(value)) {
          offenders.add('${entry.key} in $path: "$value"');
        }
        // The translator notes are read by whoever writes the next language.
        if (value is Map &&
            value['description'] is String &&
            _worldCup.hasMatch(value['description'] as String)) {
          offenders.add(
            '${entry.key} description in $path: '
            '"${value['description']}"',
          );
        }
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'these strings still say the trademarked name; they should say '
          '"World Championship", or be rephrased where it will not fit:\n'
          '${offenders.join('\n')}',
    );
  });

  test('no challenge says "World Cup" either', () {
    // The challenge catalogue is English fallback behind an id→l10n resolver,
    // so nothing here normally reaches a screen. It is still the wording a
    // missing resolver would fall back to.
    final source = File(
      'lib/domain/services/achievements/challenges.dart',
    ).readAsStringSync();
    expect(source, isNot(_saysWorldCup));
  });

  test('the stored honour name is unchanged', () {
    // Existing saves key their honours on this exact string.
    expect(worldCupHonourName, 'World Championship');
  });
}
