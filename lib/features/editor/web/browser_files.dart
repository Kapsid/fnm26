import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:web/web.dart' as web;

/// Files in and out of the browser, for the web editor only (this library
/// needs a browser: it is never imported by the app).

/// Asks for a file with the browser's file dialog and returns a blob URL
/// for it (null when nothing is picked): the "path" the editor's pickers
/// hand over, which `readPickedFile` reads back. Any file, or only those
/// ending in one of [extensions].
Future<String?> pickFileAsBlobUrl({List<String>? extensions}) async {
  final picked = await FilePicker.pickFiles(
    type: extensions == null ? FileType.any : FileType.custom,
    allowedExtensions: extensions,
    withData: true,
  );
  final bytes = picked?.files.single.bytes;
  return bytes == null ? null : _blobUrl(bytes, 'application/octet-stream');
}

/// Hands [bytes] to the browser as a download named [fileName].
void downloadBytes(Uint8List bytes, String fileName, {required String type}) {
  final url = _blobUrl(bytes, type);
  final link = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName
    ..style.display = 'none';
  web.document.body!.append(link);
  link
    ..click()
    ..remove();
  // The browser has taken its copy once the download starts.
  unawaited(
    Future<void>.delayed(
      const Duration(minutes: 1),
      () => web.URL.revokeObjectURL(url),
    ),
  );
}

String _blobUrl(Uint8List bytes, String type) => web.URL.createObjectURL(
  web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: type)),
);
