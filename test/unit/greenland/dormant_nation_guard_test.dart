import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The base nation list must not leak into a career.
///
/// `NationRepository.all()` and `nationsProvider` are the BASE world: no
/// dormant nation, and every replaced nation still in it. A reader inside a
/// career that used them would show San Marino in a Greenland world (a
/// phantom host, a pot member, a friendly offer) or lose Greenland outright
/// (a `firstWhere` that throws, an "A nation" label). Inside a career the
/// list comes from `forCareer(careerId)` / `careerNationsProvider`; outside
/// one, a lookup uses `everyKnown()` / `knownNationsByIdProvider`.
///
/// This scans lib/ and fails on any new use of the base list outside the
/// screens that are global by nature (the new-game pickers).
void main() {
  /// What each file may read of the base world, by symbol, and why. Any
  /// other base read in the same file is still caught.
  const allowlist = <String, Set<String>>{
    // nationsProvider and nationStrengthsProvider themselves: the new-game
    // world, before any career exists.
    'lib/features/nations/nation_select_providers.dart': {
      'nationRepositoryProvider.all',
      'nationsProvider',
      'nationStrengthsProvider',
    },
    'lib/features/nations/nation_select_screen.dart': {'nationsProvider'},
    'lib/features/nations/nation_select_tablet_layout.dart': {
      'nationsProvider',
      'nationStrengthsProvider',
    },
    // The out-of-work start is a new game too.
    'lib/features/career/unemployed_start_screen.dart': {'nationsProvider'},
    // Only shown by the new-game pickers above (no career in scope).
    'lib/features/nations/nation_preview.dart': {
      'nationsProvider',
      'nationStrengthsProvider',
    },
  };

  // `.all()`, `.freeDemo()`, or either passed as a tear-off (`.all` with no
  // call), straight off the repository provider.
  final baseAll = RegExp(
    r'nationRepositoryProvider\)\s*\.\s*(all|freeDemo)\b(?!\s*[A-Za-z_])',
  );
  final baseProvider = RegExp(
    r'(?<![A-Za-z_])(nationsProvider|nationStrengthsProvider)\b',
  );
  // `final repo = ref.read(nationRepositoryProvider);` ... `repo.all()`.
  final repoVar = RegExp(
    r'(\w+)\s*=\s*\w+\s*\.\s*(?:read|watch)\(\s*nationRepositoryProvider\s*\)\s*;',
  );

  List<String> offenders() {
    final out = <String>[];
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      final path = f.path.replaceAll(r'\', '/');
      final allowed = allowlist[path] ?? const <String>{};
      // Comments do not count: blank every `//` comment, keeping offsets.
      final src = f.readAsStringSync().replaceAllMapped(
        RegExp(r'//[^\n]*'),
        (m) => ' ' * m.group(0)!.length,
      );
      int lineOf(int offset) =>
          '\n'.allMatches(src.substring(0, offset)).length + 1;
      void hit(int offset, String symbol) {
        if (!allowed.contains(symbol)) {
          out.add('$path:${lineOf(offset)} $symbol');
        }
      }

      for (final m in baseAll.allMatches(src)) {
        hit(m.start, 'nationRepositoryProvider.${m.group(1)}');
      }
      for (final m in baseProvider.allMatches(src)) {
        hit(m.start, m.group(1)!);
      }
      for (final v in repoVar.allMatches(src)) {
        final call = RegExp(
          '\\b${v.group(1)}\\s*\\.\\s*(all|freeDemo)\\b(?!\\s*[A-Za-z_])',
        );
        for (final m in call.allMatches(src, v.end)) {
          hit(m.start, 'nationRepositoryProvider.${m.group(1)}');
        }
      }
    }
    return out;
  }

  test('nothing inside a career reads the base nation list', () {
    expect(
      offenders(),
      isEmpty,
      reason:
          'Inside a career use forCareer(careerId) or careerNationsProvider; '
          'outside one, everyKnown() or knownNationsByIdProvider for lookups. '
          'If the file truly has no career (a new-game screen), add it to the '
          'allowlist with the reason.',
    );
  });

  test('the scan sees what it is meant to catch', () {
    expect(
      baseAll.hasMatch('await ref.watch(nationRepositoryProvider).all();'),
      isTrue,
    );
    expect(
      baseAll.hasMatch('ref\n  .read(nationRepositoryProvider)\n  .all()'),
      isTrue,
    );
    expect(baseProvider.hasMatch('ref.watch(nationsProvider)'), isTrue);
    expect(baseProvider.hasMatch('ref.watch(nationStrengthsProvider)'), isTrue);
    // freeDemo, and a tear-off of either.
    expect(
      baseAll.hasMatch('await ref.read(nationRepositoryProvider).freeDemo();'),
      isTrue,
    );
    expect(
      baseAll.hasMatch('loader(ref.read(nationRepositoryProvider).all);'),
      isTrue,
    );
    // forCareer and everyKnown are not base reads.
    expect(
      baseAll.hasMatch('ref.read(nationRepositoryProvider).forCareer(1)'),
      isFalse,
    );
    expect(
      baseAll.hasMatch('ref.read(nationRepositoryProvider).allFor(1)'),
      isFalse,
    );
    expect(
      baseProvider.hasMatch('ref.watch(careerNationsProvider(1))'),
      isFalse,
    );
    expect(
      repoVar.hasMatch('final repo = ref.read(nationRepositoryProvider);'),
      isTrue,
    );
    // The allowlist names real files, so a rename cannot silently widen it.
    for (final path in allowlist.keys) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
  });
}
