import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';

/// The competition is the "World Championship" in everything the manager
/// reads. [worldCupHonourName] is the one exception, and only because it is a
/// STORED value: change it and every honour already recorded in a save points
/// at a competition that no longer exists.
void main() {
  test('no achievement says "World Cup"', () {
    for (final a in AchievementCatalog.all) {
      expect(a.title, isNot(contains('World Cup')), reason: a.id);
      expect(a.description, isNot(contains('World Cup')), reason: a.id);
    }
  });

  test('nothing the manager reads, in any language, says "World Cup"', () {
    // Every string in both catalogues, not only the achievements: the phrase
    // is a registered trademark in this exact context, and it leaked back in
    // one screen at a time — the trophy cabinet, the record book's best
    // finish, the heading on a background tournament's popup — each of them a
    // string that was printed raw instead of going through the translator.
    for (final path in ['lib/l10n/app_en.arb', 'lib/l10n/app_cs.arb']) {
      final arb =
          jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      for (final entry in arb.entries) {
        final value = entry.value;
        if (value is String) {
          expect(
            value,
            isNot(contains('World Cup')),
            reason: '${entry.key} in $path',
          );
        }
        // The translator notes are read by whoever writes the next language.
        if (value is Map && value['description'] is String) {
          expect(
            value['description'],
            isNot(contains('World Cup')),
            reason: '${entry.key} description in $path',
          );
        }
      }
    }
  });

  test('no challenge says "World Cup" either', () {
    // The challenge catalogue is English fallback behind an id→l10n resolver,
    // so nothing here normally reaches a screen. It is still the wording a
    // missing resolver would fall back to.
    final source = File(
      'lib/domain/services/achievements/challenges.dart',
    ).readAsStringSync();
    expect(source, isNot(contains('World Cup')));
  });

  test('the stored honour name is unchanged', () {
    // Existing saves key their honours on this exact string.
    expect(worldCupHonourName, 'World Championship');
  });
}
