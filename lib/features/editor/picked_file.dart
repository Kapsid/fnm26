// Reads a file the editor's pickers handed over by path: a file on the
// device, or (in the web editor) a blob URL the browser made for it.
export 'picked_file_io.dart'
    if (dart.library.js_interop) 'picked_file_web.dart';
