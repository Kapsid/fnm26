import 'dart:typed_data';

import 'package:archive/archive.dart';

/// [bytes] gzipped.
Uint8List gzipBytes(List<int> bytes) => const GZipEncoder().encodeBytes(bytes);

/// [bytes] unzipped into [sink]. Not streamed: the browser unzips the whole
/// file, then the sink sees it in chunks and may still refuse it.
void gunzipInto(Uint8List bytes, Sink<List<int>> sink) {
  final out = const GZipDecoder().decodeBytes(bytes);
  const chunk = 32 * 1024;
  for (var i = 0; i < out.length; i += chunk) {
    sink.add(
      Uint8List.sublistView(
        out,
        i,
        i + chunk > out.length ? out.length : i + chunk,
      ),
    );
  }
  sink.close();
}
