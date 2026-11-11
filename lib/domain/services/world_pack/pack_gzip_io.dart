import 'dart:io';
import 'dart:typed_data';

/// [bytes] gzipped.
Uint8List gzipBytes(List<int> bytes) => Uint8List.fromList(gzip.encode(bytes));

/// [bytes] unzipped into [sink], streamed in chunks so a sink that refuses
/// more (throws) stops the unzip there.
void gunzipInto(Uint8List bytes, Sink<List<int>> sink) {
  final conversion = gzip.decoder.startChunkedConversion(sink);
  const chunk = 32 * 1024;
  for (var i = 0; i < bytes.length; i += chunk) {
    conversion.add(
      Uint8List.sublistView(
        bytes,
        i,
        i + chunk > bytes.length ? bytes.length : i + chunk,
      ),
    );
  }
  conversion.close();
}
