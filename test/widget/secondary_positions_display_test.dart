import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/learned_positions.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/tactics/player_slot_sheet.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// Where the positions a player also plays, and the ones he is learning,
/// show: his page, and the slot picker's "2nd" badge.
void main() {
  Future<void> pumpPlayer(
    WidgetTester tester,
    SeededSave save,
    int playerId,
  ) async {
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: PlayerView(careerId: save.careerId, playerId: playerId),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  Future<List<Player>> pool(WidgetTester tester, SeededSave save) async {
    late List<Player> out;
    await tester.runAsync(() async {
      out = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
            careerId: save.career.id,
          );
    });
    return out;
  }

  testWidgets('his page names the positions he also plays, with their fit', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final him = (await pool(
      tester,
      save,
    )).firstWhere((p) => PositionFit.secondaryOf(p).isNotEmpty);
    await pumpPlayer(tester, save, him.id);
    expect(tester.takeException(), isNull);
    final also = PositionFit.secondaryOf(him);
    expect(
      find.descendant(
        of: find.byKey(PlayerDetailScreen.positionFactKey),
        matching: find.textContaining(
          enL.playerAlsoPlays(also.map((s) => s.position.label).join(', ')),
        ),
      ),
      findsOneWidget,
    );
    for (final s in also) {
      expect(
        find.byKey(PlayerDetailScreen.secondaryKey(s.position)),
        findsOneWidget,
      );
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('his page shows a position he is learning, then has learned', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final strikers = [
      for (final p in await pool(tester, save))
        if (p.position == PlayerPosition.st) p,
    ];
    final him = strikers[0];
    final other = strikers[1];
    Future<void> start(Player p, int times) => tester.runAsync(() async {
      for (var i = 0; i < times; i++) {
        await save.container
            .read(playerRepositoryProvider)
            .recordPositionStarts(save.careerId, [
              (player: p, position: PlayerPosition.am),
            ], aging: CareerService.agingYears(save.career));
      }
    });
    await start(him, 7);
    await start(other, 30);
    await pumpPlayer(tester, save, him.id);
    expect(tester.takeException(), isNull);
    final row = find.byKey(PlayerDetailScreen.learningKey(PlayerPosition.am));
    expect(row, findsOneWidget);
    final text = (tester.widget<Text>(row).textSpan!).toPlainText();
    expect(text, contains(enL.playerLearningPosition('AM')));
    expect(text, contains(enL.recordsMatchesCount(7)));
    expect(text, contains('●●○○○'));

    await tester.pumpWidget(const SizedBox());
    await pumpPlayer(tester, save, other.id);
    final done =
        (tester
                .widget<Text>(
                  find.byKey(PlayerDetailScreen.learningKey(PlayerPosition.am)),
                )
                .textSpan!)
            .toPlainText();
    expect(done, enL.playerLearnedPosition('AM'));
    expect(LearnedPositions.learnedAt, lessThan(30));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the slot picker marks a man playing a secondary position', (
    tester,
  ) async {
    final save = await seedSave(tester);
    late List<PlayerPosition> places;
    late Player him;
    late int disc;
    await tester.runAsync(() async {
      final c = save.container;
      final squad = (await c.read(squadDataProvider(save.careerId).future))!;
      final tactic = (await c
          .read(tacticsRepositoryProvider)
          .tacticForCareer(save.careerId))!;
      places = tactic.positions;
      // A disc whose place is one of a squad man's secondary positions.
      for (var i = 1; i < places.length; i++) {
        final hit = squad.pool
            .where((p) => PositionFit.secondaryAt(p, places[i]) != null)
            .firstOrNull;
        if (hit != null) {
          him = hit;
          disc = i;
          break;
        }
      }
      await c.read(nextEventProvider(save.careerId).future);
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
    );
    await tester.tap(find.byKey(ValueKey('pitchDisc$disc')));
    await settle(tester);
    // His sheet opens; Swap lists the men who could play there.
    await tester.tap(find.byKey(SlotSheetKeys.swap));
    await settle(tester);
    await tester.scrollUntilVisible(
      find.byKey(SecondaryTag.secondBadgeKey(him.id)),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.byKey(SecondaryTag.secondBadgeKey(him.id)), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(SecondaryTag.secondBadgeKey(him.id)),
        matching: find.text(enL.tacticsSecondBadge.toUpperCase()),
      ),
      findsOneWidget,
    );
    await tester.tapAt(const Offset(5, 5));
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
  });
}
