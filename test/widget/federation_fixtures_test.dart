import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/squad/training_camp.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The fakes later tasks lean on must be what they say they are.
void main() {
  test('a solo host offers its four camps, three hosts two each', () {
    final solo = fakeCampPlan(campHosts(1));
    expect(solo.options, hasLength(TrainingCamps.count));
    expect(solo.decided, isFalse);
    final shared = fakeCampPlan(campHosts(3));
    expect(shared.options, hasLength(6));
    expect(shared.hostNames, hasLength(3));
    expect(campHosts(3), isNot(contains(seededNationId)));
  });

  test('the Y feed: three conversations, a seam, Ana twice', () {
    final feed = fakeYTimeline();
    expect(feed.posts, hasLength(7));
    expect(feed.reserveFrom, 6);
    expect(feed.posts.where((p) => p.handle == '@AnaFan'), hasLength(2));
  });

  testWidgets('an offer lands on the save; the budget can be marked set', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final offer = await offerNaturalization(tester, save);
    await markBudgetSet(tester, save);
    await tester.runAsync(() async {
      final sub = save.container.listen(
        pendingNaturalizationProvider(save.careerId).future,
        (_, _) {},
      );
      final pending = await sub.read();
      sub.close();
      expect(pending?.player.id, offer.playerId);
      expect(pending?.sourceNation.id, offer.sourceNationId);
      expect(
        await save.container
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(
              save.careerId,
              save.career.cyclePointer,
              budgetSetupKind,
            ),
        isTrue,
      );
    });
  });

  testWidgets('a manager with points has them to spend', (tester) async {
    final save = await seedSave(tester, overrides: [managerWithPoints(2)]);
    await tester.runAsync(() async {
      final sub = save.container.listen(
        managerViewProvider(save.careerId).future,
        (_, _) {},
      );
      final view = await sub.read();
      sub.close();
      expect(view?.pointsAvailable, 2);
    });
  });
}
