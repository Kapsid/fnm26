import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';

import '../helpers/fixtures.dart';
import '../helpers/test_database.dart';

void main() {
  test('a step refreshes an inbox that a listener keeps alive', () async {
    // The tablet's top bar watches the unread count for the shell's whole
    // life, so the auto-disposed inbox behind it is never torn down between
    // steps. A step that files news must therefore invalidate it by hand.
    final db = createTestDatabase();
    final nations = [
      for (var i = 1; i <= 6; i++) nation(id: i, ranking: i),
      nation(id: 7, ranking: 7, confederation: Confederation.asia),
    ];
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(db.close);
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: 1, managerName: 'A'))
            .valueOrNull!;
    final id = career.id;
    // Sync the welcome news, read it, and start from a clean slate.
    await container.read(messageInboxProvider(id).future);
    await container.read(competitionRepositoryProvider).markMessagesRead(id);
    container
      ..invalidate(messageInboxProvider(id))
      ..invalidate(unreadMessagesProvider(id));

    // The listener is the top bar.
    final sub = container.listen(unreadMessagesProvider(id), (_, _) {});
    addTearDown(sub.close);
    expect(await container.read(unreadMessagesProvider(id).future), 0);

    await container
        .read(competitionRepositoryProvider)
        .addMessage(
          careerId: id,
          dedupKey: 'fresh-from-a-step',
          category: 'ranking',
          title: 'Fresh from a step',
          body: 'Body',
          year: 2026,
        );
    await container.read(seasonServiceProvider).advance(id);

    expect(
      await container.read(unreadMessagesProvider(id).future),
      greaterThan(0),
    );
    final inbox = await container.read(messageInboxProvider(id).future);
    expect(inbox.messages.map((m) => m.title), contains('Fresh from a step'));
  });
}
