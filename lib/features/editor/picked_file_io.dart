import 'dart:io';
import 'dart:typed_data';

/// The bytes of the picked file at [path], or null when it is over
/// [maxBytes] (measured before anything is read into memory).
Future<Uint8List?> readPickedFile(String path, {required int maxBytes}) async {
  final file = File(path);
  if (await file.length() > maxBytes) return null;
  return file.readAsBytes();
}
