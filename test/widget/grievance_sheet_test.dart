import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/squad/grievances.dart';
import 'package:fnm/features/squad/grievance_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

const Key _openKey = Key('test.openGrievance');

/// Opens the grievance sheet as the hub's event button does (a bottom sheet
/// on a phone, a root dialog on a tablet), on the seeded save.
Future<SeededSave> _openSheet(WidgetTester tester, Size size) async {
  final save = await seedSave(tester);
  final player = squadOf(save.nationId).first;
  final grievance = (
    playerId: player.id,
    playerName: player.name,
    kind: GrievanceKind.gameTime,
    age: 24,
    caps: 3,
    key: 'grievance:test:${player.id}',
  );
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: save.container,
      child: MaterialApp(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              key: _openKey,
              onPressed: () => showAdaptiveSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => GrievanceSheet(
                  careerId: save.careerId,
                  grievance: grievance,
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(_openKey));
  await settle(tester);
  expect(find.byType(GrievanceSheet), findsOneWidget);
  return save;
}

Future<int> _answers(WidgetTester tester, SeededSave save) async {
  late int n;
  await tester.runAsync(() async {
    n =
        (await save.container
                .read(careerRepositoryProvider)
                .pressAnswers(save.careerId))
            .length;
  });
  return n;
}

/// A tap delivered synchronously, with no frame and no microtask after it.
void _syncTap(WidgetTester tester, Offset at, int pointer) {
  tester.binding
    ..handlePointerEvent(PointerDownEvent(pointer: pointer, position: at))
    ..handlePointerEvent(PointerUpEvent(pointer: pointer, position: at));
}

/// A double tap used to answer the player twice: two press-answer rows, so
/// the morale and board deltas counted twice. The first answer now holds the
/// sheet until it lands.
Future<void> _doubleAnswer(WidgetTester tester, Size size) async {
  final save = await _openSheet(tester, size);
  expect(await _answers(tester, save), 0);
  // Both taps go in back to back, before any microtask runs: an in-memory
  // database answers within microtasks, so awaited taps would let the first
  // answer land (and the sheet start closing) before the second.
  final reassure = tester.getCenter(find.text(enL.grievanceReassure));
  final honest = tester.getCenter(find.text(enL.grievanceHonest));
  _syncTap(tester, reassure, 1);
  _syncTap(tester, honest, 2);
  await settle(tester);
  expect(tester.takeException(), isNull);
  expect(await _answers(tester, save), 1);
  expect(find.byType(GrievanceSheet), findsNothing, reason: 'answered');
  await tester.pumpWidget(const SizedBox());
}

void main() {
  testWidgets('two tones tapped at once answer once, phone', (tester) async {
    await _doubleAnswer(tester, kPhoneSize);
  });

  testWidgets('two tones tapped at once answer once, tablet', (tester) async {
    await _doubleAnswer(tester, kTabletSize);
  });
}
