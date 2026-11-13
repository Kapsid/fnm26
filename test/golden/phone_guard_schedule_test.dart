import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/hub/schedule_screen.dart';
import 'package:fnm/features/hub/schedule_widgets.dart';

import '../helpers/seeded_save.dart';

/// The phone schedule (1.1.2 redesign, variant C): month cards with
/// weekday-and-day rows, the draw still to be watched as a dashed gold row,
/// and the Mine / Competitions / Draws chips.
void main() {
  testWidgets('phone schedule, qualifying draw still to watch', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.schedule}?careerId=${save.careerId}',
    );
    expect(find.byKey(ScheduleScreen.todayKey), findsOneWidget);
    expect(find.byType(ScheduleDrawRow), findsWidgets);
    await expectAppGolden('goldens/schedule_phone.png');
  });

  testWidgets('phone schedule, draw watched', (tester) async {
    final save = await seedSave(tester);
    await watchContinentalQualifyingDraw(tester, save);
    await pumpRoute(
      tester,
      save,
      '${Routes.schedule}?careerId=${save.careerId}',
    );
    expect(find.byType(ScheduleFixtureRow), findsWidgets);
    await expectAppGolden('goldens/schedule_phone_drawn.png');
  });
}
