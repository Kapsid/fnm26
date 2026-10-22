import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';
import '../helpers/seeded_save.dart' show enL;

/// A friendly has no substitution cap but the bench; a competitive match keeps
/// five (six in extra time). The engine itself never limits the changes.

Finder _onPitchName(String text) => find.byWidgetPredicate(
  (w) => w is Text && w.data?.replaceAll('\u200b', '') == text,
  description: 'pitch name "$text"',
);

/// Opens the slot picker on [starterName] and looks for [benchName] under
/// each of its tabs; returns whether he is offered (the picker is left open).
Future<bool> _offered(
  WidgetTester tester,
  String starterName,
  String benchName,
) async {
  await tester.tap(_onPitchName(starterName.toUpperCase()).last);
  await tester.pumpAndSettle();
  if (find.text(benchName).evaluate().isEmpty) {
    for (final tab in [enL.tacticsTabOnPitch, enL.tacticsTabOtherPositions]) {
      final chip = find.text(tab);
      if (chip.evaluate().isEmpty) continue;
      await tester.tap(chip.last);
      await tester.pumpAndSettle();
      if (find.text(benchName).evaluate().isNotEmpty) break;
    }
  }
  return find.text(benchName).evaluate().isNotEmpty;
}

/// Puts [benchName] into the slot [starterName] occupies, through the slot
/// picker (the same path as `in_match_sub_undo_test.dart`).
Future<void> _substitute(
  WidgetTester tester,
  String starterName,
  String benchName,
) async {
  expect(
    await _offered(tester, starterName, benchName),
    isTrue,
    reason: '$benchName is offered for $starterName',
  );
  final target = find.text(benchName).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

/// The editor after five changes (7-11 replaced by 12-16), with 17 and 18 still
/// fresh on the bench, under [maxSubs].
Future<void> _openSheet(WidgetTester tester, {required int maxSubs}) async {
  const formation = Formation.f442;
  final pool = [
    for (var i = 0; i < 11; i++)
      player(
        id: i + 1,
        nationId: 1,
        name: 'Starter${i + 1}',
        position: formation.positions[i],
      ),
    for (var i = 12; i <= 18; i++) player(id: i, nationId: 1, name: 'Bench$i'),
  ];
  await tester.binding.setSurfaceSize(const Size(400, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (inner) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showInMatchTactics(
                  inner,
                  minute: 60,
                  formation: formation,
                  lineup: const [1, 2, 3, 4, 5, 6, 12, 13, 14, 15, 16],
                  instructions: const TacticalInstructions(),
                  pool: pool,
                  startingIds: {for (var i = 1; i <= 11; i++) i},
                  maxSubs: maxSubs,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the cap: the bench in a friendly, else five (six in extra time)', () {
    int cap({bool friendly = false, bool et = false}) => maxSubsAllowed(
      friendly: friendly,
      benchSize: 12,
      extraTime: et,
    );
    expect(cap(friendly: true), 12);
    expect(cap(friendly: true, et: true), 12);
    expect(cap(), kMaxSubs);
    expect(cap(et: true), kMaxSubsExtraTime);
  });

  testWidgets('in a friendly the editor accepts a sixth and a seventh', (
    tester,
  ) async {
    final cap = maxSubsAllowed(friendly: true, benchSize: 12, extraTime: false);
    await _openSheet(tester, maxSubs: cap);
    await _substitute(tester, 'Starter2', 'Bench17');
    expect(find.text(enL.tacticsSubsUsed(6, cap)), findsWidgets);
    await _substitute(tester, 'Starter3', 'Bench18');
    expect(find.text(enL.tacticsSubsUsed(7, cap)), findsWidgets);
    expect(find.text(enL.tacticsTooManySubs(cap)), findsNothing);
  });

  testWidgets('a competitive match still refuses the sixth', (tester) async {
    final cap = maxSubsAllowed(
      friendly: false,
      benchSize: 12,
      extraTime: false,
    );
    await _openSheet(tester, maxSubs: cap);
    expect(
      await _offered(tester, 'Starter2', 'Bench17'),
      isFalse,
      reason: 'five made of five, no one is left to bring on',
    );
  });

  test('the engine plays eight changes for the manager side', () {
    final home = ratedTeam(1, 75);
    final bench = [
      for (var i = 0; i < 8; i++)
        player(id: 190 + i, nationId: 1, name: 'Fresh$i'),
    ];
    final r = const MatchEngine().play(
      home: home,
      away: ratedTeam(2, 75),
      rng: SeededRng.forFixture(0xF1, 7),
      subs: [
        for (var i = 0; i < 8; i++)
          Substitution(
            teamNationId: 1,
            minute: 46 + i * 5,
            offId: 100 + i,
            on: bench[i],
          ),
      ],
    );
    final ons = r.events
        .where(
          (e) =>
              e.type == MatchEventType.substitution &&
              e.teamNationId == 1 &&
              e.playerId >= 190,
        )
        .length;
    expect(ons, 8);
  });
}
