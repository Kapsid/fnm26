import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/contact.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/settings/settings_screen.dart'
    show linkLauncherProvider;

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

/// The database home points fans at the community Discord, as sharing between
/// players and not as official content.
void main() {
  for (final tablet in [false, true]) {
    testWidgets(
      'the Discord row opens the invite, ${tablet ? 'tablet' : 'phone'}',
      (
        tester,
      ) async {
        final opened = <Uri>[];
        final c = await editorContainer(
          tester,
          formFactor: tablet ? FormFactor.tablet : FormFactor.phone,
          overrides: [
            linkLauncherProvider.overrideWithValue((u) async {
              opened.add(u);
              return true;
            }),
          ],
        );
        final id = await insertPack(tester, c, testPack('Community'));
        await pumpEditorRoute(
          tester,
          c,
          editorPackLocation(id),
          size: tablet ? kTabletSizes.first : kPhoneSize,
        );
        final row = find.byKey(PackHomeScreen.communityKey);
        if (!tablet) {
          await tester.scrollUntilVisible(
            row,
            300,
            scrollable: find.byType(Scrollable).first,
          );
        }
        expect(row, findsOneWidget);
        expect(find.text(enL.editorCommunityTitle), findsOneWidget);
        expect(find.text(enL.editorCommunityAbout), findsOneWidget);
        await tester.tap(row);
        await tester.pump();
        expect(opened.map((u) => u.toString()), [kDiscordUrl]);
      },
    );
  }
}
