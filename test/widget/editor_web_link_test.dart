import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/contact.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/editor/editor_list_screen.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/settings/settings_screen.dart'
    show linkLauncherProvider;

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

/// The editor is also on the site. The app's editor list says so (and opens
/// it); the web editor, which IS that page, does not.
void main() {
  /// Whatever the row last put on the clipboard.
  String? copied;

  setUp(() {
    copied = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  final title = enL.editorWebTitle(kWebEditorAddress);

  for (final tablet in [false, true]) {
    final where = tablet ? 'tablet' : 'phone';

    testWidgets('the app shows the web editor row and a tap opens it, '
        '$where', (tester) async {
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
      await pumpEditorRoute(
        tester,
        c,
        Routes.editor,
        size: tablet ? kTabletSizes.first : kPhoneSize,
      );
      final row = find.byKey(EditorListScreen.webEditorKey);
      expect(row, findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(enL.editorWebAbout), findsOneWidget);
      await tester.tap(row);
      await tester.pump();
      expect(opened.map((u) => u.toString()), [kWebEditorUrl]);
      expect(copied, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the web editor itself has no such row, $where', (
      tester,
    ) async {
      final c = await editorContainer(
        tester,
        formFactor: tablet ? FormFactor.tablet : FormFactor.phone,
        overrides: [editorHasHomeProvider.overrideWithValue(false)],
      );
      await pumpEditorRoute(
        tester,
        c,
        Routes.editor,
        size: tablet ? kTabletSizes.first : kPhoneSize,
      );
      expect(find.byType(EditorListScreen), findsOneWidget);
      expect(find.byKey(EditorListScreen.webEditorKey), findsNothing);
      expect(find.text(title), findsNothing);
    });
  }

  testWidgets('a phone that cannot open it copies the address', (
    tester,
  ) async {
    final c = await editorContainer(
      tester,
      overrides: [linkLauncherProvider.overrideWithValue((u) async => false)],
    );
    await pumpEditorRoute(tester, c, Routes.editor, size: kPhoneSize);
    await tester.tap(find.byKey(EditorListScreen.webEditorKey));
    await tester.pumpAndSettle();
    expect(copied, kWebEditorUrl);
    expect(find.text(enL.settingsLinkCopied), findsOneWidget);
  });

  testWidgets('a long press copies the address without opening it', (
    tester,
  ) async {
    final opened = <Uri>[];
    final c = await editorContainer(
      tester,
      overrides: [
        linkLauncherProvider.overrideWithValue((u) async {
          opened.add(u);
          return true;
        }),
      ],
    );
    await pumpEditorRoute(tester, c, Routes.editor, size: kPhoneSize);
    await tester.longPress(find.byKey(EditorListScreen.webEditorKey));
    await tester.pumpAndSettle();
    expect(copied, kWebEditorUrl);
    expect(opened, isEmpty);
    expect(find.text(enL.settingsLinkCopied), findsOneWidget);
  });
}
