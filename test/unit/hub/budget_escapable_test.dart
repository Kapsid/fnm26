import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';

import '../../helpers/test_database.dart';

/// The budget is a forced event and must stay one — but forced and
/// inescapable are different things. A manager who opens it to look at the
/// numbers has to be able to leave without spending the money, and then be
/// asked again.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('leaving the budget unset leaves it as the next event', () async {
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;

    // It is the first thing the save asks for.
    expect(
      (await container.read(nextEventProvider(career.id).future)).kind,
      HubEventKind.budget,
    );

    // Walking away changes nothing — the manager is asked again, and again.
    for (var visit = 0; visit < 3; visit++) {
      container.invalidate(nextEventProvider(career.id));
      expect(
        (await container.read(nextEventProvider(career.id).future)).kind,
        HubEventKind.budget,
        reason: 'visit $visit: an unspent budget must still be demanded',
      );
    }

    // Only actually distributing it moves the save on.
    await container
        .read(competitionRepositoryProvider)
        .markDrawWatched(career.id, career.cyclePointer, budgetSetupKind);
    container.invalidate(nextEventProvider(career.id));
    expect(
      (await container.read(nextEventProvider(career.id).future)).kind,
      isNot(HubEventKind.budget),
    );
  });
}
