import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/manager/manager_age.dart';
import 'package:fnm/domain/services/world_managers/manager_news.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/manager/manager_age_widgets.dart';

import '../../helpers/test_database.dart';

/// The manager's own age (release 1.1.2): a birth year set at creation,
/// shown with the in-game date, and never read by the sim.
void main() {
  group('ManagerAge', () {
    test('a birth year is the year minus the age, held in range', () {
      expect(ManagerAge.birthYearFor(2026, 45), 1981);
      expect(ManagerAge.birthYearFor(2026, 12), 2026 - ManagerAge.min);
      expect(ManagerAge.birthYearFor(2026, 99), 2026 - ManagerAge.max);
    });

    test('ages with the in-game date, and is null without a birth year', () {
      expect(ManagerAge.on(1981, DateTime(2026, 7)), 45);
      expect(ManagerAge.on(1981, DateTime(2034, 6)), 53);
      expect(ManagerAge.on(null, DateTime(2034, 6)), isNull);
    });

    test('reads only a whole age from 30 to 75', () {
      expect(ManagerAge.parse('45'), 45);
      expect(ManagerAge.parse(' 30 '), 30);
      expect(ManagerAge.parse('75'), 75);
      expect(ManagerAge.parse('29'), isNull);
      expect(ManagerAge.parse('76'), isNull);
      expect(ManagerAge.parse(''), isNull);
      expect(ManagerAge.parse('4x'), isNull);
    });
  });

  group('career creation', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = createTestDatabase();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);
    });

    test('stores the age given as a birth year', () async {
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: 7,
                    managerName: 'Alex',
                    managerAge: 52,
                  ))
              .valueOrNull!;
      expect(career.managerBirthYear, 2026 - 52);
      expect(managerAgeOf(career), 52);
      expect(
        await container.read(managerAgeQuestionProvider(career.id).future),
        isFalse,
        reason: 'a career made with an age is never asked for one',
      );
    });

    test('without an age the hub asks once, and Skip ends it', () async {
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: 7, managerName: 'Old'))
              .valueOrNull!;
      expect(career.managerBirthYear, isNull);
      expect(managerAgeOf(career), isNull);
      expect(
        await container.read(managerAgeQuestionProvider(career.id).future),
        isTrue,
      );
      await container
          .read(competitionRepositoryProvider)
          .markDrawWatched(career.id, 0, managerAgeAskedKind);
      container.invalidate(managerAgeQuestionProvider(career.id));
      expect(
        await container.read(managerAgeQuestionProvider(career.id).future),
        isFalse,
      );
      // Skipped: still no age, and nothing else about the career moved.
      final again = await container
          .read(careerRepositoryProvider)
          .byId(career.id);
      expect(again!.managerBirthYear, isNull);
    });

    test('an answer is stored as of the in-game date', () async {
      final repo = container.read(careerRepositoryProvider);
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: 7, managerName: 'Later'))
              .valueOrNull!;
      await repo.setManagerBirthYear(
        career.id,
        ManagerAge.birthYearFor(career.inGameDate.year, 61),
      );
      final read = await repo.byId(career.id);
      expect(managerAgeOf(read!), 61);
    });
  });

  group('retirement news', () {
    test('names a retiring manager with his age', () {
      final msg = ManagerNews.message(
        (
          nationId: 3,
          outgoingId: 11,
          why: SpellEnd.retired,
          incomingId: null,
          date: DateTime(2031, 7),
        ),
        nation: 'Ruritania',
        outgoing: 'Ota Brnak',
        incoming: null,
        outgoingAge: 61,
      )!;
      final title = msg.title as MsgText;
      expect(title.key, MsgKey.mgrNewsRetiredAge);
      expect(title.args, ['Ruritania', 'Ota Brnak', 61]);
      // The profile link still finds him by name.
      expect(
        ManagerNews.namesIn((title: title, body: msg.body, note: null)),
        ['Ota Brnak'],
      );
    });

    test('without an age it reads as it always did', () {
      final msg = ManagerNews.message(
        (
          nationId: 3,
          outgoingId: 11,
          why: SpellEnd.retired,
          incomingId: null,
          date: DateTime(2031, 7),
        ),
        nation: 'Ruritania',
        outgoing: 'Ota Brnak',
        incoming: null,
      )!;
      expect((msg.title as MsgText).key, MsgKey.mgrNewsRetired);
    });

    test('only a retirement carries the age', () {
      final msg = ManagerNews.message(
        (
          nationId: 3,
          outgoingId: 11,
          why: SpellEnd.sacked,
          incomingId: null,
          date: DateTime(2031, 7),
        ),
        nation: 'Ruritania',
        outgoing: 'Ota Brnak',
        incoming: null,
        outgoingAge: 61,
      )!;
      expect((msg.title as MsgText).key, MsgKey.mgrNewsSacked);
    });
  });
}
