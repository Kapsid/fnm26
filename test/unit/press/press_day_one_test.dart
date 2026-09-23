import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

/// The press used to open a career by asking about things the manager had not
/// done. Portugal's new manager was congratulated on a cup won in 2025,
/// Argentina's was told his place at the finals was booked — a host's
/// automatic berth — and Spain's was asked about a ranking peak that was
/// simply where the nation started.
void main() {
  late List<Nation> nations;
  late List<Player> players;

  setUpAll(() {
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
  });

  /// The question a brand-new manager of [code] is asked, before a ball has
  /// been kicked.
  Future<PressTopic?> dayOneTopic(String code) async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    final nation = nations.firstWhere((n) => n.code == code);
    final career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: nation.id,
                  managerName: 'M',
                ))
            .valueOrNull!;
    return (await container.read(
      pressQuestionProvider(career.id).future,
    ))?.topic;
  }

  // ARG hosts its continental cup in a fresh save (an automatic berth), POR
  // and MEX hold a 2025 trophy in the seeded roll of honour, and ESP starts
  // high enough to read as its own ranking peak. Each reproduced a different
  // wrong question.
  for (final code in ['ARG', 'POR', 'MEX', 'ESP', 'ENG', 'NZL']) {
    test('$code is asked about the job, not about somebody else\'s', () async {
      final topic = await dayOneTopic(code);
      expect(
        topic,
        anyOf(isNull, PressTopic.newJob),
        reason:
            'a manager who has not managed a match yet was asked about '
            '${topic?.name}',
      );
    });
  }
}
