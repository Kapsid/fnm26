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
    _expectNoEnglish(_dartFiles('lib/domain'));
  });

  /// The same sweep over the layer the first one could not see.
  ///
  /// `lib/domain` was cleared and four English phrases carried on being
  /// printed, because they were decided in `lib/features` instead: "Iconic" on
  /// the rollover badge, "Step up" on a job offer, "Semi-finals" and "Did not
  /// qualify" on the career history, and "Knocked out in the Quarter-finals"
  /// over a bracket. A provider is no more able to reach [AppLocalizations]
  /// than an entity is, so the rule and the fix are the same: the words live
  /// in `lib/l10n` and a translator at the display edge writes them.
  test('nor does anything in lib/features', () {
    _expectNoEnglish(_dartFiles('lib/features'));
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

/// The few SINGLE-word all-caps literals that are display rather than data.
///
/// Named one at a time on purpose. `lib/features` holds 167 single-word
/// all-caps literals and nearly all of them are canonical round codes —
/// `GROUP`, `FINAL`, `CGROUP`, `NGROUP`, `FRIENDLY` — that are compared in
/// logic and never printed. Sweeping the shape would bury the real ones; this
/// list is the opt-in for a word that turned out to be a plate after all.
const List<String> _displayCapsWords = ['PENALTIES', 'MASCOT', 'DRAWING…'];

/// The two shapes a hard-coded display string takes in this repo.
///
/// The first is an arrow or a `return` handing back a literal that starts like
/// an English sentence or name — the shape every label getter had. Keyed on
/// the OPENING of the literal rather than its whole content, so
/// `=> 'Top $n advance'` is caught as surely as `=> 'Striker'`.
///
/// The second is a multi-word ALL-CAPS phrase ANYWHERE on the line, with no
/// `=>` or `return` in front of it. Caps is how this app writes a plate, a
/// banner or an app-bar title, and none of those is returned from a getter:
/// they sit inline in a `Text(...)` or in the ternary that chooses between
/// two of them. The first shape could not see them for two reasons at once —
/// no arrow, and `[A-Z][a-z]` cannot begin on a capital followed by another
/// capital — which is how a Czech manager kept reading "FULL TIME",
/// "GOLDEN BOOT", "DRAW COMPLETE" and "SEEDING POTS" through four batches of
/// this sweep.
final RegExp _displayLiteral = RegExp(
  r"(?:=>|return)\s+'([A-Z][a-z][^']*)'"
  r"|'((?:[A-Z0-9]{2,}(?:[ ·]+[A-Z0-9]{2,})+"
  '|${_displayCapsWords.join('|')}'
  r")[^']*)'",
);

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
  // A typography specimen on the developer-only style gallery, which is the
  // one screen whose job IS to show the type at its worst. It is not routed
  // to from the app and no manager can reach it, so the caps string is the
  // sample, not copy.
  'lib/features/dev/style_gallery_screen.dart': {'LABEL · MONO'},
};

Iterable<File> _dartFiles(String dir) => Directory(dir)
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    // Generated code writes its own English (`toString` dumps every field
    // name) and is not hand-edited.
    .where((f) => !f.path.endsWith('.freezed.dart'))
    .where((f) => !f.path.endsWith('.g.dart'));

/// Fails naming every file and line that hands back English, so one run tells
/// you the whole list rather than the first of it.
void _expectNoEnglish(Iterable<File> files) {
  final offences = <String>[];
  for (final file in files) {
    final path = file.path;
    final allowed = _allowed[path] ?? const <String>{};
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      // A line that already names a translator is the FIX, not the fault:
      // `=> l.somethingLabel` never matches, but a doc comment quoting an old
      // getter would, so comments are skipped.
      if (line.trimLeft().startsWith('//')) continue;
      for (final m in _displayLiteral.allMatches(line)) {
        // Whichever of the two shapes matched: the arrow/`return` one fills
        // group 1, the all-caps one group 2.
        final literal = m.group(1) ?? m.group(2)!;
        if (allowed.any(literal.startsWith)) continue;
        offences.add('$path:${i + 1}  "$literal"');
      }
    }
  }
  expect(
    offences,
    isEmpty,
    reason:
        'these hand back English the manager can read, and nothing under '
        'lib/ can translate it:\n  ${offences.join('\n  ')}\n'
        'Move the words to lib/l10n and print them through a translator at '
        'the display edge. If the value is CANONICAL (stored in a save or '
        'compared in logic) add it to _allowed with the reason.',
  );
}
