import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// iPhone 17 Pro: 402 x 874 points at 3x, so 1206 x 2622 pixels, the size
/// the marketing frames expect.
const Size kStorySize = Size(402, 874);
const double kStoryDpr = 3;
const Key kStoryRoot = Key('story.root');

final String storyOut =
    Platform.environment['STORY_OUT'] ?? 'build/story_screens';

Future<void> loadMaterialIcons() async {
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable).parent.parent.parent.parent.parent.path;
  final file = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (!file.existsSync()) {
    throw StateError('no material icons font at ${file.path}');
  }
  final bytes = await file.readAsBytes();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  // What iOS falls back to for glyphs the app's own faces lack (the draw's
  // tick marks): the test engine has no system fallback of its own.
  // The website shots also need the faces iOS falls back to for Japanese,
  // Korean, Thai and Devanagari (Hanken Grotesk and SF carry none of them).
  for (final (family, path) in const [
    ('StorySF', '/System/Library/Fonts/SFNS.ttf'),
    ('StoryJP', '/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc'),
    ('StoryJP', '/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc'),
    ('StoryKR', '/System/Library/Fonts/AppleSDGothicNeo.ttc'),
    ('StoryTH', '/System/Library/Fonts/ThonburiUI.ttc'),
    ('StoryHI', '/System/Library/Fonts/Kohinoor.ttc'),
    ('StorySymbols', '/System/Library/Fonts/Apple Symbols.ttf'),
  ]) {
    final f = File(path);
    if (!f.existsSync()) continue;
    final b = await f.readAsBytes();
    await (FontLoader(
      family,
    )..addFont(Future.value(ByteData.sublistView(b)))).load();
  }
}

const List<String> _fallback = [
  'StorySF',
  'StoryJP',
  'StoryKR',
  'StoryTH',
  'StoryHI',
  'StorySymbols',
];

TextStyle? _fb(TextStyle? s) => s?.copyWith(fontFamilyFallback: _fallback);

ButtonStyle? _fbButton(ButtonStyle? b) => b?.copyWith(
  textStyle: b.textStyle == null
      ? null
      : WidgetStateProperty.resolveWith(
          (states) => _fb(b.textStyle!.resolve(states)),
        ),
);

/// The app theme with the fallback faces on every style that REPLACES the
/// ambient text style rather than merging into it (app bar titles, button
/// labels, dialogs): those would otherwise draw missing glyphs as boxes in
/// the test engine, which has no system fallback.
ThemeData get storyTheme {
  final t = AppTheme.theme;
  return t.copyWith(
    textTheme: t.textTheme.apply(fontFamilyFallback: _fallback),
    primaryTextTheme: t.primaryTextTheme.apply(fontFamilyFallback: _fallback),
    appBarTheme: t.appBarTheme.copyWith(
      titleTextStyle: _fb(t.appBarTheme.titleTextStyle),
      toolbarTextStyle: _fb(t.appBarTheme.toolbarTextStyle),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: _fbButton(t.filledButtonTheme.style),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _fbButton(t.elevatedButtonTheme.style),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _fbButton(t.outlinedButtonTheme.style),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _fbButton(t.textButtonTheme.style),
    ),
    dialogTheme: t.dialogTheme.copyWith(
      titleTextStyle: _fb(t.dialogTheme.titleTextStyle),
      contentTextStyle: _fb(t.dialogTheme.contentTextStyle),
    ),
    snackBarTheme: t.snackBarTheme.copyWith(
      contentTextStyle: _fb(t.snackBarTheme.contentTextStyle),
    ),
  );
}

void setPhone(WidgetTester tester) {
  tester.view
    ..physicalSize = kStorySize * kStoryDpr
    ..devicePixelRatio = kStoryDpr
    ..padding = const FakeViewPadding(
      top: 62 * kStoryDpr,
      bottom: 34 * kStoryDpr,
    )
    ..viewPadding = const FakeViewPadding(
      top: 62 * kStoryDpr,
      bottom: 34 * kStoryDpr,
    );
  addTearDown(tester.view.reset);
}

/// Pumps the real app router on [container], opened at [location].
Future<void> pumpApp(
  WidgetTester tester,
  ProviderContainer container,
  String location, {
  Locale locale = const Locale('en'),
}) async {
  if (locale.languageCode != 'en') {
    // As the Settings picker sets it, so screens that read the language
    // (Settings itself, translated nation names) see it too.
    container.read(localeProvider.notifier).state = locale;
  }
  final router = container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    RepaintBoundary(
      key: kStoryRoot,
      child: UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: storyTheme,
          builder: (context, child) => DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: _fallback),
            child: child!,
          ),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    ),
  );
}

/// Writes what the screen shows now to `<storyOut>/<name>.png`.
Future<void> shoot(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(kStoryRoot),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: kStoryDpr);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$storyOut/$name.png')..createSync(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
  // ignore: avoid_print
  print('SHOT $name');
}
