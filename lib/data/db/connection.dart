// The database is opened natively on phones and tablets, and in the browser
// for the web editor (`lib/main_editor_web.dart`).
export 'connection_native.dart'
    if (dart.library.js_interop) 'connection_web.dart';
