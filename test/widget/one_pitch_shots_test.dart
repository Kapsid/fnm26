import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';
import 'package:fnm/features/tactics/player_slot_sheet.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/fixtures.dart';
import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

/// Where screenshots go when `ONE_PITCH_SHOTS` names a folder; without it
/// the screens are only checked.
final String? _shotsDir = Platform.environment['ONE_PITCH_SHOTS'];

Future<void> _shot(WidgetTester tester, String name) async {
  final dir = _shotsDir;
  if (dir == null) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(kAppRoot),
  );
  await tester.runAsync(() async {
    final img = await boundary.toImage(pixelRatio: 2);
    final png = await img.toByteData(format: ui.ImageByteFormat.png);
    Directory(dir).createSync(recursive: true);
    File('$dir/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
    img.dispose();
  });
}

/// Every mark a disc wears stays clear of the others on it: the role badge's
/// touch area, the arrow mark (or the full-back's push mark) and the
/// position badge on top.
void main() {
  // For the pictures, the real icon font, so a role's glyph and a run's
  // arrow read as they do on the phone rather than as test boxes.
  setUpAll(() async {
    if (_shotsDir == null) return;
    final icons = File(
      '${Platform.environment['FLUTTER_ROOT'] ?? '/opt/flutter'}'
      '/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    if (!icons.existsSync()) return;
    final bytes = icons.readAsBytesSync();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  });

  for (final f in [Formation.f433, Formation.f442]) {
    testWidgets('career tactics, ${f.label}', (tester) async {
      final save = await seedSave(tester);
      final id = save.careerId;
      final repo = save.container.read(tacticsRepositoryProvider);
      // Roles on a few men, a run or two, and the left-back pushed on. Written straight to
      // the store: the service's writes also ask the hub's next event
      // again, which this save never opened, and that answer outlives the
      // test (the taps themselves are the pitch and Classic tests').
      final picks = f == Formation.f433
          ? {
              0: PlayerRole.sweeperKeeper,
              2: PlayerRole.ballPlayingDefender,
              7: PlayerRole.playmaker,
              9: PlayerRole.falseNine,
              10: PlayerRole.invertedWinger,
            }
          : {
              2: PlayerRole.stopper,
              6: PlayerRole.ballWinner,
              7: PlayerRole.boxToBox,
              9: PlayerRole.targetMan,
              10: PlayerRole.poacher,
            };
      final runs = f == Formation.f433
          ? {8: MoveArrow.back, 6: MoveArrow.forward, 3: MoveArrow.forward}
          : {5: MoveArrow.back, 8: MoveArrow.forwardInside};
      await tester.runAsync(() async {
        var t = (await repo.tacticForCareer(id))!.copyWith(formation: f);
        for (final e in picks.entries) {
          t = t.withRole(e.key, e.value);
        }
        for (final e in runs.entries) {
          t = t.withArrow(e.key, e.value);
        }
        t = t.withArrow(1, MoveArrow.forward);
        await repo.saveTactic(id, t);
      });
      await pumpRoute(tester, save, '${Routes.tactics}?careerId=$id');
      await settle(tester);
      expect(find.byType(SegmentedButton<bool>), findsNothing);
      for (final s in picks.keys) {
        expect(find.byKey(PitchPlanKeys.tag(s)), findsOneWidget);
      }
      expect(find.byKey(PitchPlanKeys.arrows), findsOneWidget);
      // A tap on the man opens his sheet on the career screen too.
      final disc = find.byKey(const ValueKey('pitchDisc7'));
      await tester.ensureVisible(disc);
      await tester.pumpAndSettle();
      await tester.tap(disc);
      await settle(tester);
      expect(find.byKey(SlotSheetKeys.sheet), findsOneWidget);
      Navigator.of(tester.element(find.byKey(SlotSheetKeys.sheet))).pop();
      await settle(tester);
      // The pitch from its top, the hint under it.
      await tester.ensureVisible(find.byType(TacticsPitch));
      await tester.pumpAndSettle();
      await _shot(tester, 'career_${f.name}');
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });

    testWidgets('in-match editor, ${f.label}', (tester) async {
      final players = [
        for (var i = 0; i < 11; i++)
          player(
            id: i + 1,
            nationId: 1,
            name:
                'Player ${[
                  'Novak', 'Kral', 'Dvorak', 'Svoboda', 'Cerny', //
                  'Prochazka', 'Kucera', 'Vesely', 'Horak', 'Nemec', //
                  'Pokorny',
                ][i]}',
            position: f.positions[i],
          ),
        for (var i = 12; i <= 16; i++)
          player(
            id: i,
            nationId: 1,
            name: 'Bench$i',
            position: f.positions[i - 11],
          ),
      ];
      final roles = f == Formation.f433
          ? const SlotRoles({
              2: PlayerRole.ballPlayingDefender,
              5: PlayerRole.anchor,
              7: PlayerRole.playmaker,
              9: PlayerRole.pressingForward,
            })
          : const SlotRoles({
              3: PlayerRole.coveringDefender,
              6: PlayerRole.deepPlaymaker,
              9: PlayerRole.targetMan,
              10: PlayerRole.poacher,
            });
      await openEditor(
        tester,
        size: const Size(390, 844),
        formation: f,
        players: players,
        roles: roles,
        cardsByPlayer: {7: MatchCard.yellow},
        energyByPlayer: {
          for (var i = 1; i <= 11; i++) i: 100 - i * 4,
        },
      );
      expect(find.byType(SegmentedButton<bool>), findsNothing);
      // One more role and some runs through the men's sheets, and the
      // right-back pushed on.
      Future<void> inSheet(int slot, List<Key> keys) async {
        await tester.tap(find.byKey(ValueKey('pitchDisc$slot')));
        await tester.pumpAndSettle();
        for (final k in keys) {
          await tester.ensureVisible(find.byKey(k));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(k));
          await tester.pumpAndSettle();
        }
        Navigator.of(tester.element(find.byKey(SlotSheetKeys.sheet))).pop();
        await tester.pumpAndSettle();
      }

      final extra = f == Formation.f433 ? 10 : 5;
      await inSheet(extra, [
        SlotSheetKeys.role(PlayerRole.invertedWinger),
        SlotSheetKeys.run(MoveArrow.forwardInside),
      ]);
      await inSheet(f == Formation.f433 ? 6 : 7, [
        SlotSheetKeys.run(MoveArrow.forward),
      ]);
      await inSheet(4, [SlotSheetKeys.run(MoveArrow.forward)]);
      expect(find.byKey(const ValueKey('pitchFullBack4')), findsOneWidget);
      expect(find.byKey(PitchPlanKeys.arrows), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await _shot(tester, 'in_match_${f.name}');
    });
  }
}
