import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

import 'fixtures.dart';
import 'seeded_save.dart';

/// Eleven starters (1..11) in a 4-4-2 and five on the bench (12..16, 16 a
/// keeper).
List<Player> editorSquad() => [
  for (var i = 0; i < 11; i++)
    player(
      id: i + 1,
      nationId: 1,
      name: 'Starter${i + 1}',
      position: Formation.f442.positions[i],
    ),
  for (var i = 12; i <= 16; i++)
    player(
      id: i,
      nationId: 1,
      name: 'Bench$i',
      position: i == 16 ? PlayerPosition.gk : PlayerPosition.cm,
    ),
];

/// Where the editor's confirmed setup lands: [result] stays null until the
/// manager taps Apply, and is also null if he backs out.
class EditorOutcome {
  InMatchTacticsResult? result;
}

/// Opens the real editor over a launcher at 70', as the match screen does.
/// [lineup] defaults to the eleven starters; pass one with nulls for a side
/// that has had men sent off (with their ids in [sentOffIds]).
///
/// Both the view and the surface are sized: the view decides MediaQuery (and
/// so whether the window is tablet sized), the surface what a pushed route is
/// laid out in.
Future<EditorOutcome> openEditor(
  WidgetTester tester, {
  required Size size,
  bool tabletLayout = false,
  List<TacticPreset> presets = const [],
  Set<int> sentOffIds = const {},
  Map<int, MatchCard> cardsByPlayer = const {},
  List<int?>? lineup,
}) async {
  final outcome = EditorOutcome();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final players = editorSquad();
  await tester.pumpWidget(
    RepaintBoundary(
      key: kAppRoot,
      child: ProviderScope(
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (inner) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    outcome.result = await showInMatchTactics(
                      inner,
                      minute: 70,
                      formation: Formation.f442,
                      lineup: lineup ?? [for (var i = 1; i <= 11; i++) i],
                      instructions: const TacticalInstructions(),
                      pool: players,
                      startingIds: {for (var i = 1; i <= 11; i++) i},
                      maxSubs: 5,
                      sentOffIds: sentOffIds,
                      cardsByPlayer: cardsByPlayer,
                      tabletLayout: tabletLayout,
                      presets: presets,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return outcome;
}
