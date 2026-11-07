import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The youth bonus is built on the nation's intake standing (its ranking and
/// what it won, per cycle). Refreshing the bonus alone left the standing
/// under it as it was, so a screen holding both kept rating the boys on the
/// standing from before the step. Wherever the bonus is refreshed by hand,
/// the standing must be refreshed with it.
void main() {
  test('every refresh of the youth bonus refreshes the standing under it', () {
    final missing = <String>[];
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      final src = f.readAsStringSync();
      final bonus = 'invalidate(youthBonusByCycleProvider'.allMatchesIn(src);
      final standing = 'invalidate(intakeStandingByCycleProvider'.allMatchesIn(
        src,
      );
      if (bonus > standing) missing.add('${f.path}: $bonus vs $standing');
    }
    expect(missing, isEmpty);
  });
}

extension on String {
  int allMatchesIn(String src) => allMatches(src).length;
}
