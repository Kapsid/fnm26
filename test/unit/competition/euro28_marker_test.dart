import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/euro_qualifying28.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../story/driver.dart';

/// The EURO 2028 shape of Europe's qualifying for the continental finals is
/// a per-cycle marker (`Euro28.kind`): a new career on the 1.1.2 calendar
/// carries it from cycle 0, one that opts out (or one on the old calendar)
/// does not, so a save from before it keeps its shape until its next
/// rollover stamps the new cycle.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Future<bool> marked({bool calendar2 = true, bool euro28 = true}) async {
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
                  euro28: euro28,
                ))
            .valueOrNull!;
    return isEuro28(c.read(competitionRepositoryProvider), career.id, 0);
  }

  test('a new career carries it from cycle 0', () async {
    expect(await marked(), isTrue);
  });

  test('an opt-out or the old calendar does not', () async {
    expect(await marked(euro28: false), isFalse);
    expect(await marked(calendar2: false), isFalse);
  });
}
