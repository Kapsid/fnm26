import 'dart:typed_data';

import 'package:image_picker/image_picker.dart' show XFile;

/// The bytes of the picked file at [path] (a blob URL in the browser), or
/// null when it is over [maxBytes].
Future<Uint8List?> readPickedFile(String path, {required int maxBytes}) async {
  final file = XFile(path);
  if (await file.length() > maxBytes) return null;
  return file.readAsBytes();
}
