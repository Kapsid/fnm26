import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/club_history_card.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  late int playerId;
  await tester.runAsync(() async {
    final pool = await save.container
        .read(playerRepositoryProvider)
        .byNation(
          save.nationId,
          agingYears: CareerService.agingYears(save.career),
          saveSeed: save.career.rngSeed,
          careerId: save.career.id,
        );
    playerId = pool.first.id;
  });
  await pumpRoute(
    tester,
    save,
    '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('who he is left, what he has done right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(PlayerDetailScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final profile = tester.getRect(find.byKey(PlayerDetailScreen.profileKey));
      final record = tester.getRect(find.byKey(PlayerDetailScreen.recordKey));
      expect(record.left, greaterThan(profile.right));
      expect(
        find.descendant(
          of: find.byKey(PlayerDetailScreen.profileKey),
          matching: find.text(enL.playerAttributes.toUpperCase()),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(PlayerDetailScreen.recordKey),
          matching: find.text(enL.playerCareerRecord),
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('his club and club history sit on the right, once', (
    tester,
  ) async {
    await _open(tester, const Size(1080, 810));
    expect(tester.takeException(), isNull);
    final profile = find.byKey(PlayerDetailScreen.profileKey);
    final club = find.byKey(PlayerDetailScreen.clubKey);
    expect(
      find.descendant(
        of: find.byKey(PlayerDetailScreen.recordKey),
        matching: club,
      ),
      findsOneWidget,
    );
    for (final label in [
      enL.playerClub,
      enL.playerClubRole.toUpperCase(),
    ]) {
      expect(
        find.descendant(of: club, matching: find.text(label)),
        findsOneWidget,
        reason: label,
      );
      expect(
        find.descendant(of: profile, matching: find.text(label)),
        findsNothing,
        reason: label,
      );
    }
    expect(
      find.descendant(of: club, matching: find.byType(ClubHistoryCard)),
      findsOneWidget,
    );
    expect(find.byType(ClubHistoryCard), findsOneWidget);
    // The club sits above the career record in that column.
    expect(
      tester.getTopLeft(club).dy,
      lessThan(tester.getTopLeft(find.text(enL.playerCareerRecord)).dy),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('back with nothing to pop goes to the hub', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    final uri = save.container
        .read(routerProvider)
        .routeInformationProvider
        .value
        .uri;
    expect(uri.path, Routes.hub);
    expect(uri.queryParameters['careerId'], '${save.careerId}');
    await tester.pumpWidget(const SizedBox());
  });
}
