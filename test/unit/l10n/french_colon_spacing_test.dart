import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// French sets a colon off with a space before it, and app_fr.arb writes that
/// space as a no-break space (U+00A0) so the colon never wraps onto a line of
/// its own. A colon that ends a clause ("…: la suite") must have one.
void main() {
  test('every French clause colon has a no-break space before it', () {
    final arb =
        jsonDecode(File('lib/l10n/app_fr.arb').readAsStringSync())
            as Map<String, dynamic>;
    final bad = <String>[];
    final clauseColon = RegExp(r'(.):(\s|$)');
    for (final e in arb.entries) {
      if (e.key.startsWith('@') || e.value is! String) continue;
      for (final m in clauseColon.allMatches(e.value as String)) {
        if (m.group(1) != ' ') bad.add(e.key);
      }
    }
    expect(bad, isEmpty);
  });
}
