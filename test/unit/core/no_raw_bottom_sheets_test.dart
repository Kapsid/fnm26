import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every sheet goes through `showAdaptiveSheet`, which is a bottom sheet on a
/// phone and a dialog on a tablet. A raw `showModalBottomSheet` would slide a
/// phone-width strip up the bottom of an iPad.
void main() {
  test('no raw showModalBottomSheet outside adaptive_sheet.dart', () {
    final offenders = <String>[];
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      if (f.path.endsWith('adaptive_sheet.dart')) continue;
      if (f.readAsStringSync().contains('showModalBottomSheet')) {
        offenders.add(f.path);
      }
    }
    expect(offenders, isEmpty);
  });
}
