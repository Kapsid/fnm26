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

  test('no achievement string in any language says "World Cup"', () {
    // The titles the manager actually reads are localised; the definitions
    // above are only the fallback.
    for (final path in ['lib/l10n/app_en.arb', 'lib/l10n/app_cs.arb']) {
      final arb =
          jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      for (final entry in arb.entries) {
        if (!entry.key.startsWith('ach')) continue;
        final value = entry.value;
        if (value is! String) continue;
        expect(
          value,
          isNot(contains('World Cup')),
          reason: '${entry.key} in $path',
        );
      }
    }
  });

  test('the stored honour name is unchanged', () {
    // Existing saves key their honours on this exact string.
    expect(worldCupHonourName, 'World Championship');
  });
}
