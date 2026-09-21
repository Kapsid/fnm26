import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the app's OWN typefaces before any test runs.
///
/// Without this a widget test renders in Flutter's fallback face, which draws
/// every glyph a full em wide where Hanken Grotesk is nearer six tenths of
/// that. Every width test in this repo was therefore measuring a screen about
/// forty per cent wider than the one on the phone: pessimistic, which is the
/// safe direction, but it made marginal failures meaningless and it hid the
/// opposite mistake — a layout tuned until the FALLBACK font fitted.
///
/// The pitch is what forced the issue. Its discs are as large as the spacing
/// allows, so whether a surname wraps inside one is a question of a few
/// points, and it cannot be answered in a font the app does not ship.
///
/// `flutter_test_config.dart` is picked up automatically for every test in
/// this directory and below.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFont('Hanken Grotesk', 'assets/fonts/HankenGrotesk-Variable.ttf');
  await _loadFont('JetBrains Mono', 'assets/fonts/JetBrainsMono-Variable.ttf');
  await testMain();
}

Future<void> _loadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = await file.readAsBytes();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
}
