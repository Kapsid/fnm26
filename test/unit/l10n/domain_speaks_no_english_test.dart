import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The domain layer does not write the words the manager reads.
///
/// A Czech manager kept meeting English — "Buoyant" on his hub badge, "Youth
/// Academy" in his federation, "Centre Back" on a player, "Poacher" in the role
/// picker — and every one of them had the same cause: an enum in `lib/domain`
/// carried an English `label` getter, and the widget printed it. `lib/domain`
/// cannot import [AppLocalizations] (it has no business knowing about widgets),
/// so a label getter there can only ever be English, in every language.
///
/// The fix was a translator at the DISPLAY edge, keyed off the enum value —
/// `competitionLabel`, `positionName`, `playerRoleLabel`, `moraleLabel`,
/// `departmentLabel`. This test is what stops the English growing back: it
/// scans `lib/domain` for the shape those getters had, an arrow or a `return`
/// handing back a capitalised English phrase, and fails on anything not named
/// in [_allowed] below.
///
/// Adding to [_allowed] is not forbidden — it is how a CANONICAL value (one
/// that is stored in a save, or compared in logic) declares itself. Write the
/// reason next to it. Anything the manager READS belongs with the copy in
/// `lib/l10n/` instead.
void main() {
  test('nothing in lib/domain returns a display string in English', () {
    final offenders = <String>[];
    for (final file in _domainFiles()) {
      final path = file.path;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        // Comments explain the code in English and always will.
        if (line.trimLeft().startsWith('//')) continue;
        for (final m in _displayLiteral.allMatches(line)) {
          final literal = m.group(2)!;
          if (_allowed[path]?.any(literal.startsWith) ?? false) continue;
          offenders.add('$path:${i + 1}  \'$literal\'');
        }
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'these read like words the manager sees, written in the one layer '
          'that cannot translate them:\n  ${offenders.join('\n  ')}\n'
          'Put the words in lib/l10n/app_en.arb and app_cs.arb and translate '
          'at the display edge (see lib/core/util/squad_label.dart), or — if '
          'the string is a CANONICAL value that is stored or compared — add it '
          'to _allowed in this test with the reason.',
    );
  });

  test('the enums a manager reads carry no label getter at all', () {
    // The narrow version of the sweep above, naming the five that were found
    // in front of a Czech player. A getter is easy to add back without
    // noticing; these files say outright that it must not be.
    const gone = {
      'lib/domain/entities/enums.dart': ['String get roleName'],
      'lib/domain/entities/player_role.dart': [
        'String get label',
        'String get blurb',
      ],
      'lib/domain/services/federation/federation_finance.dart': [
        'String get label',
        'String get blurb',
        'static String nameFor',
      ],
      'lib/domain/services/achievements/challenges.dart': ['String get label'],
      'lib/domain/services/squad/condition.dart': ['static String moraleLabel'],
    };
    for (final entry in gone.entries) {
      final source = File(entry.key).readAsStringSync();
      for (final member in entry.value) {
        expect(
          source,
          isNot(contains(member)),
          reason:
              '${entry.key} has grown back `$member`: the words it returns '
              'cannot be translated there. Translate at the display edge '
              'instead.',
        );
      }
    }
  });
}

/// An arrow or a `return` handing back a literal that starts like an English
/// sentence or name — the shape every label getter in this repo had.
///
/// Keyed on the OPENING of the literal rather than its whole content, so
/// `=> 'Top $n advance'` is caught as surely as `=> 'Striker'`.
final RegExp _displayLiteral = RegExp(r"(=>|return)\s+'([A-Z][a-z][^']*)'");

/// Canonical strings: stored in saves or compared in logic, so they are
/// identifiers that happen to be spelled in English, not copy.
///
/// Each entry is matched as a PREFIX of the literal, so one line covers a
/// sentence built by interpolation.
const Map<String, Set<String>> _allowed = {
  // The confederation's English name is half of a STORED competition name
  // ("Europe Qualifiers", built in schedule_generator.dart) and is compared
  // back against it in competition_label.dart. Changing it orphans every
  // qualifying fixture in every existing save. `confederationLabel(l, c)` is
  // what a screen prints.
  'lib/domain/entities/enums.dart': {
    'Europe',
    'South America',
    'North America',
    'Africa',
    'Asia',
    'Oceania',
  },
  // Reachable from no screen: `GroupAdvancement.caption` is exercised only by
  // its own unit test, and the group tables write their own zone captions from
  // the copy. Left in English rather than translated for a caller that does
  // not exist.
  'lib/domain/services/competition/group_advancement.dart': {'Only '},
};

Iterable<File> _domainFiles() => Directory('lib/domain')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    // Generated code writes its own English (`toString` dumps every field
    // name) and is not hand-edited.
    .where((f) => !f.path.endsWith('.freezed.dart'))
    .where((f) => !f.path.endsWith('.g.dart'));
