import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every save-bound player read names its career.
///
/// A player's name is derived on every read from the save seed AND the
/// career's name pools (see `namePoolsV2Kind`). A read that passes `saveSeed`
/// but no `careerId` falls back to the classic pools, so in a new career that
/// one screen would call a player something different from everywhere else.
/// Nothing at compile time catches that, so this reads the source.
void main() {
  test('no player read in lib passes saveSeed without careerId', () {
    expect(
      _offenders('lib', (args) => args.contains('saveSeed:')),
      isEmpty,
    );
  });

  // A test that reads a real career's players (its seed taken from the
  // career) compares them with what the screens show, so it must name the
  // career too. Repository tests with a bare number for a seed are left be.
  test('no test reads a career\'s players without its careerId', () {
    expect(
      _offenders(
        'test',
        (args) => args.contains(RegExp(r'saveSeed: [^,)]*rngSeed')),
      ),
      isEmpty,
    );
  });
}

/// Every `byNation(` / `youthByNation(` / `byId(` call under [dir] whose
/// argument list matches [isSaveBound] but names no `careerId:`.
List<String> _offenders(String dir, bool Function(String) isSaveBound) {
  final call = RegExp(r'\.(byNation|youthByNation|byId)\(');
  final offenders = <String>[];
  for (final file in Directory(dir).listSync(recursive: true)) {
    if (file is! File || !file.path.endsWith('.dart')) continue;
    if (file.path.endsWith('drift_player_repository.dart')) continue;
    if (file.path.endsWith('player_reads_name_career_test.dart')) continue;
    final src = file.readAsStringSync();
    for (final m in call.allMatches(src)) {
      // The argument list, up to the matching parenthesis.
      var depth = 1;
      var i = m.end;
      while (depth > 0 && i < src.length) {
        final c = src[i++];
        if (c == '(') depth++;
        if (c == ')') depth--;
      }
      final args = src.substring(m.end, i - 1);
      if (isSaveBound(args) && !args.contains('careerId:')) {
        final line = '\n'.allMatches(src.substring(0, m.start)).length + 1;
        offenders.add('${file.path}:$line');
      }
    }
  }
  return offenders;
}
