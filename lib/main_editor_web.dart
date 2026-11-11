import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/editor/web/web_editor_app.dart';

/// The web database editor (footballnationsmanager.com/editor/): the app's
/// editor alone, served as static files. Build with
/// `flutter build web --release -t lib/main_editor_web.dart --base-href
/// /editor/` (see docs/site/EDITOR_WEB.md).
///
/// The default world is seeded into SQLite in the browser (WebAssembly, kept
/// in IndexedDB); files come in through the browser's file dialog and go out
/// as downloads. Nothing leaves the visitor's machine.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: webEditorOverrides,
      child: const WebEditorApp(),
    ),
  );
}
