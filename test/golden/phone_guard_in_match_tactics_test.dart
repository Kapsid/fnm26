import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/app_segmented_tabs.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone in-match editor', (tester) async {
    await openEditor(tester, size: kPhoneSize);
    expect(find.byType(AppSegmentedControl), findsOneWidget);
    await expectAppGolden('goldens/in_match_tactics_phone.png');
  });
}
