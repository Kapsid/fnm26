import 'dart:convert';
import 'dart:io';

import '../test/helpers/match_baseline.dart';

/// Writes test/fixtures/match_baseline.json from the CURRENT engine. Re-run only
/// when an outcome-changing engine change is intended.
///   dart run tool/capture_match_baseline.dart
void main() {
  final out = {
    'figures': measureFigures(),
    'golden': measureGolden(),
    'longThrowGolden': measureLongThrowGolden(),
  };
  File('test/fixtures/match_baseline.json')
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder().convert(out));
  stdout.writeln('wrote test/fixtures/match_baseline.json');
}
