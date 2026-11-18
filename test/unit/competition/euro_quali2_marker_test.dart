import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../story/driver.dart';

/// The real UEFA shape of Europe's World Championship qualifying is a
/// per-cycle marker (`UefaWcPlayoffs.kind2`): a new career on the 1.1.2
/// calendar carries it from cycle 0, one that opts out (or one on the old
/// calendar) does not, so a save from before it keeps its shape until its
/// next rollover stamps the new cycle.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Future<bool> marked({bool calendar2 = true, bool euroQuali2 = true}) async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: england,
                  managerName: 'M',
                  rngSeed: 5,
                  calendar2: calendar2,
                  euroQuali2: euroQuali2,
                ))
            .valueOrNull!;
    return isEuroQuali2(
      c.read(competitionRepositoryProvider),
      career.id,
      0,
    );
  }

  test('a new career carries it from cycle 0', () async {
    expect(await marked(), isTrue);
  });

  test('an opt-out or the old calendar does not', () async {
    expect(await marked(euroQuali2: false), isFalse);
    expect(await marked(calendar2: false), isFalse);
  });
}
