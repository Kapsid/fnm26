import 'dart:convert';
import 'dart:io';

import '../test/helpers/match_baseline.dart';

/// Writes test/fixtures/match_baseline.json from the CURRENT engine. Re-run only
/// when an outcome-changing engine change is intended.
///   dart run tool/capture_match_baseline.dart
///
/// With `--goldens-only` the exact goldens are re-captured and the `figures`
/// already in the file are kept: the figures are the reference the bands in
/// `match_baseline_test.dart` hold a recalibrated engine to, so an intended
/// outcome change regenerates the goldens without moving that reference.
void main(List<String> args) {
  const path = 'test/fixtures/match_baseline.json';
  final goldensOnly = args.contains('--goldens-only');
  final out = {
    'figures': goldensOnly
        ? (jsonDecode(File(path).readAsStringSync())
              as Map<String, dynamic>)['figures']
        : measureFigures(),
    'golden': measureGolden(),
    'longThrowGolden': measureLongThrowGolden(),
    'extraTimeGolden': measureExtraTimeGolden(),
  };
  File(path)
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder().convert(out));
  stdout.writeln(
    'wrote $path${goldensOnly ? ' (goldens only, figures kept)' : ''}',
  );
}
