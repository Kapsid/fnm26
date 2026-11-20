import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/nations/nation_detail_providers.dart';

import '../../story/driver.dart';

/// "Where they play" on a nation's page counts its squad: an AI side's best
/// [nationSquadSize], the manager's own called-up men. It used to count an
/// AI side's whole pool, youth intake and all (49 by 2031).
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('an AI side counts its squad, the manager his call-ups', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 42, nationId: 12);
    final nations = await c
        .read(nationRepositoryProvider)
        .forCareer(d.careerId);
    Future<NationDetail> read(int nationId) async {
      final sub = c.listen(
        nationDetailProvider((careerId: d.careerId, nationId: nationId)).future,
        (_, _) {},
      );
      try {
        return (await sub.read())!;
      } finally {
        sub.close();
      }
    }

    int counted(NationDetail n) =>
        n.clubCountries.fold(0, (sum, e) => sum + e.count);

    var bigger = 0;
    for (final n in nations.where(
      (n) => const ['ENG', 'BRA', 'QAT', 'JAM'].contains(n.code),
    )) {
      final page = await read(n.id);
      expect(counted(page), lessThanOrEqualTo(nationSquadSize), reason: n.code);
      if (page.now.pool.length > nationSquadSize) bigger++;
    }
    expect(bigger, greaterThan(0), reason: 'no pool was bigger than a squad');

    final own = await read(12);
    expect(counted(own), own.now.pool.length);
  }, timeout: const Timeout(Duration(minutes: 5)));
}
