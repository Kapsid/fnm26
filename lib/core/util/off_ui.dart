// Runs heavy pure work away from the UI: on a background isolate on
// devices ([Isolate.run]), inline in the browser, which has no isolates (the
// web database editor).
export 'off_ui_io.dart' if (dart.library.js_interop) 'off_ui_web.dart';
