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
///
/// With `--refigure=name[,name...]` the goldens are re-captured, the named
/// figures re-measured, and every other figure kept: for an intended change
/// to one figure (the penalty share of goals, when the penalty rate was
/// raised) that leaves the rest of the reference where it was. Every
/// figure's old and new value is printed, so what moved can be read.
void main(List<String> args) {
  const path = 'test/fixtures/match_baseline.json';
  final goldensOnly = args.contains('--goldens-only');
  final refigure = {
    for (final a in args)
      if (a.startsWith('--refigure='))
        ...a.substring('--refigure='.length).split(','),
  };
  Object? figures;
  if (goldensOnly) {
    figures =
        (jsonDecode(File(path).readAsStringSync())
            as Map<String, dynamic>)['figures'];
  } else if (refigure.isNotEmpty) {
    final kept =
        (jsonDecode(File(path).readAsStringSync())
                as Map<String, dynamic>)['figures']
            as Map<String, dynamic>;
    final now = measureFigures();
    figures = {
      for (final cell in kept.entries)
        cell.key: {
          for (final f in (cell.value as Map<String, dynamic>).entries)
            f.key: refigure.contains(f.key) ? now[cell.key]![f.key] : f.value,
        },
    };
    for (final cell in kept.entries) {
      for (final f in (cell.value as Map<String, dynamic>).entries) {
        stdout.writeln(
          '${cell.key} ${f.key}: ${f.value} -> ${now[cell.key]![f.key]}'
          '${refigure.contains(f.key) ? '  (re-pinned)' : ''}',
        );
      }
    }
  } else {
    figures = measureFigures();
  }
  final out = {
    'figures': figures,
    'golden': measureGolden(),
    'longThrowGolden': measureLongThrowGolden(),
    'extraTimeGolden': measureExtraTimeGolden(),
  };
  File(path)
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder().convert(out));
  stdout.writeln(
    'wrote $path'
    '${goldensOnly ? ' (goldens only, figures kept)' : ''}'
    '${refigure.isNotEmpty ? ' (re-pinned: ${refigure.join(', ')})' : ''}',
  );
}
