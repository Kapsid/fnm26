import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/share_origin.dart';

void main() {
  testWidgets('the global rect of the widget it is given', (tester) async {
    late BuildContext target;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            Positioned(
              left: 40,
              top: 60,
              width: 120,
              height: 30,
              child: Builder(
                builder: (context) {
                  target = context;
                  return const SizedBox.expand();
                },
              ),
            ),
          ],
        ),
      ),
    );
    expect(shareOriginOf(target), const Rect.fromLTWH(40, 60, 120, 30));
  });

  // Review Focus 3. An iPad refuses a share sheet with nowhere to point
  // (share_plus: "sharePositionOrigin: argument must be set"), and every
  // caller catches that and says the export failed.
  test('every share sheet in the app says where it points from', () {
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      final src = file.readAsStringSync();
      final shares = 'SharePlus.instance.share('.allMatches(src).length;
      final origins = 'sharePositionOrigin:'.allMatches(src).length;
      if (shares > origins) offenders.add(file.path);
    }
    expect(offenders, isEmpty);
  });
}
