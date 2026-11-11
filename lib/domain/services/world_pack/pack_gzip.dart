// The gzip under a `.fnmdb` file: `dart:io`'s on devices, a pure-Dart one
// in the browser (the web database editor), byte-compatible either way.
export 'pack_gzip_io.dart' if (dart.library.js_interop) 'pack_gzip_web.dart';
