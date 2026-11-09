import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_desk.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

ConferenceFacts _facts({TieLabel? label}) => (
  reason: ConferenceReason.bigLoss,
  bestPlayerId: null,
  worstPlayerId: null,
  hasOpenWinNext: false,
  hasOpenJob: false,
  playersWithOpenStatement: const <int>{},
  throwback: null,
  preview: null,
  opposingManager: label == null
      ? null
      : (managerId: 4, name: 'Karel Dvořák', label: label),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('no beat for a neutral manager', () {
    expect(ConferenceBuilder.opposingManagerBeat(_facts()), isNull);
    expect(
      ConferenceBuilder.opposingManagerBeat(_facts(label: TieLabel.neutral)),
      isNull,
    );
  });

  test('one beat for a rival', () {
    for (final label in TieLabel.values) {
      if (label == TieLabel.neutral) continue;
      final beat = ConferenceBuilder.opposingManagerBeat(_facts(label: label));
      expect(beat, isNotNull, reason: '$label');
      expect(beat!.kind, BeatKind.opposingManager);
      expect(beat.answers, [
        AnswerKind.hitBackAtManager,
        AnswerKind.respectManager,
      ]);
      expect(beat.playerId, isNull);
    }
    // Stored by name, so both enums only ever grow at the end.
    expect(BeatKind.values.last, BeatKind.opposingManager);
    expect(AnswerKind.values.last, AnswerKind.respectManager);
    expect(
      AnswerKind.values[AnswerKind.values.length - 2],
      AnswerKind.hitBackAtManager,
    );
    // An old save's stored answers still decode.
    expect(AnswerKind.values.byName('teamFirst'), AnswerKind.teamFirst);
    expect(AnswerKind.values.byName('deflect'), AnswerKind.deflect);
    // Neither answer is a statement anybody holds him to.
    expect(ConferenceBuilder.statementOf(AnswerKind.hitBackAtManager), isNull);
    expect(ConferenceBuilder.statementOf(AnswerKind.respectManager), isNull);
    // A name that cannot be read asks nothing.
    final unnamed = ConferenceBuilder.namedOnly(
      (
        reason: ConferenceReason.bigLoss,
        bestPlayerId: null,
        worstPlayerId: null,
        hasOpenWinNext: false,
        hasOpenJob: false,
        playersWithOpenStatement: const <int>{},
        throwback: null,
        preview: null,
        opposingManager: (managerId: 4, name: ' ', label: TieLabel.rival),
      ),
      const {},
    );
    expect(ConferenceBuilder.opposingManagerBeat(unnamed), isNull);
    expect(
      ConferenceBuilder.namedOnly(
        _facts(label: TieLabel.rival),
        const {},
      ).opposingManager?.name,
      'Karel Dvořák',
    );
  });

  group('in a career', () {
    late ProviderContainer container;
    late Career career;
    late int careerId;

    setUp(() async {
      final db = createTestDatabase();
      final nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Nation.fromJson(e as Map<String, Object?>))
              .toList();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => false),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: const []),
          ),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);
      await container.read(seedLoaderProvider).ensureSeeded();
      career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: nations.first.id,
                    managerName: 'M',
                    rngSeed: 7,
                  ))
              .valueOrNull!;
      careerId = career.id;
    });

    /// Three defeats, a conference called after the last, and a manager in
    /// charge of that match's opponent with [tie] (a grudge by default).
    Future<PendingConference> called({TieKind? tie = TieKind.grudge}) async {
      final repo = container.read(careerRepositoryProvider);
      final comp = container.read(competitionRepositoryProvider);
      final own = [
        for (final f in await comp.fixturesForNation(careerId, career.nationId))
          if (!f.hasResult && f.round != Rounds.friendly) f,
      ]..sort((a, b) => a.date.compareTo(b.date));
      final picked = own.take(3).toList();
      for (final f in picked) {
        final home = f.homeNationId == career.nationId;
        await comp.recordResult(
          fixtureId: f.id,
          homeScore: home ? 0 : 2,
          awayScore: home ? 2 : 0,
        );
      }
      await repo.updateInGameDate(
        careerId,
        picked.last.date.add(const Duration(days: 1)),
      );
      await container.read(pressDeskProvider).afterMatches(careerId);
      final pending = await container.read(
        pendingConferenceProvider(careerId).future,
      );
      expect(pending, isNotNull);
      final managers = container.read(worldManagerRepositoryProvider);
      await managers.apply(
        careerId,
        ManagerChanges(
          added: [
            WorldManager(
              managerId: 1,
              name: 'Karel Dvořák',
              nationality: 'TST',
              birthYear: 1975,
              style: 'balanced',
              origin: ManagerOrigin.fresh,
              enteredAt: DateTime(2020),
            ),
          ],
          opened: [
            ManagerSpell(
              spellNo: 1,
              managerId: 1,
              nationId: pending!.opponentNationId,
              fromDate: DateTime(2020),
              contractUntil: DateTime(2040),
            ),
          ],
        ),
      );
      if (tie != null) {
        await managers.addTie(
          careerId,
          managerId: 1,
          kind: tie,
          delta: -25,
          date: DateTime(2024),
        );
      }
      return pending;
    }

    test('conference count unchanged', () async {
      final pending = await called();
      final repo = container.read(careerRepositoryProvider);
      expect(await repo.conferences(careerId), hasLength(1));
      final c = await container
          .read(pressDeskProvider)
          .withOpposingManager(careerId, pending);
      expect(c.facts.opposingManager?.name, 'Karel Dvořák');
      expect(c.facts.opposingManager?.label, TieLabel.grudge);
      expect(c.row.id, pending.row.id);
      // The desk's own calendar is untouched: no new trigger, the same cap,
      // and running it again calls nothing more.
      await container.read(pressDeskProvider).afterMatches(careerId);
      expect(await repo.conferences(careerId), hasLength(1));
      expect(ConferenceTrigger.maxPerCycle, 6);
    });

    test('a neutral opponent manager adds nothing', () async {
      final pending = await called(tie: null);
      final c = await container
          .read(pressDeskProvider)
          .withOpposingManager(careerId, pending);
      expect(c.facts.opposingManager, isNull);
      expect(ConferenceBuilder.opposingManagerBeat(c.facts), isNull);
    });

    test('answers write the tie', () async {
      final pending = await called();
      final c = await container
          .read(pressDeskProvider)
          .withOpposingManager(careerId, pending);
      final beat = ConferenceBuilder.opposingManagerBeat(c.facts)!;
      final service = container.read(conferenceServiceProvider);
      final managers = container.read(worldManagerRepositoryProvider);

      await service.answer(careerId, c, 2, beat, AnswerKind.hitBackAtManager);
      // Answered again (the sheet reopened): written once.
      await service.answer(careerId, c, 2, beat, AnswerKind.hitBackAtManager);
      var ties = [
        for (final t in await managers.ties(careerId))
          if (t.kind == TieKind.pressDig) t,
      ];
      expect(ties, hasLength(1));
      expect(ties.single.managerId, 1);
      expect(ties.single.delta, -15);

      await service.answer(careerId, c, 3, beat, AnswerKind.respectManager);
      ties = [
        for (final t in await managers.ties(careerId))
          if (t.kind == TieKind.pressRespect) t,
      ];
      expect(ties, hasLength(1));
      expect(ties.single.delta, 10);
      expect(
        await container.read(careerRepositoryProvider).conferences(careerId),
        hasLength(1),
      );
    });
  });
}
