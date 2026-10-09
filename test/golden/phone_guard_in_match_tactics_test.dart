import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone in-match editor', (tester) async {
    await openEditor(tester, size: kPhoneSize);
    expect(find.byType(TabBar), findsOneWidget);
    await expectAppGolden('goldens/in_match_tactics_phone.png');
  });
}
