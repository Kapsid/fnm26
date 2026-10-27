import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:fnm/core/config/ui_language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';
import '../../story/driver.dart';

/// A camp scandal through the real save: offered between the call-up and the
/// window's first match, answered once, and the answer holding everywhere it
/// should (the squad, the quick-sim, the press effect, a reload, a bundle).
void main() {
  late AppDatabase db;
  late List<Nation> nations;
  late List<Player> players;
  late ProviderContainer c;
  late int careerId;
  late int nationId;
  late Fixture first;
  late List<int> squad;

  ProviderContainer open({String? language}) {
    final container = ProviderContainer(
      overrides: [
        if (language != null)
          uiLanguageCodeProvider.overrideWithValue(language),
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    List<T> load<T>(String f, T Function(Map<String, Object?>) from) =>
        (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
            .map((e) => from(e as Map<String, Object?>))
            .toList();
    nations = load('nations.json', Nation.fromJson);
    players = load('players.json', Player.fromJson);
    c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final europe =
        nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));

    // A save whose dice deal a scandal in one of its windows: the first seed
    // with one, and the first such window. Deterministic, like the game.
    final comp = c.read(competitionRepositoryProvider);
    Fixture? window;
    for (var seed = 1; window == null; seed++) {
      expect(seed, lessThan(40), reason: 'no seed dealt a scandal');
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: europe[8].id,
                    managerName: 'M',
                    rngSeed: seed,
                  ))
              .valueOrNull!;
      final sorted = (await comp.cycleFixturesForNation(
        career.id,
        career.nationId,
      ))..sort((a, b) => a.date.compareTo(b.date));
      final starts = CampScandal.windowStarts(sorted);
      for (var i = 1; i < sorted.length; i++) {
        if (!Nomination.isPeriodStart(sorted[i], sorted[i - 1])) continue;
        if (CampScandal.fires(
          seed: seed,
          cycle: 0,
          window: sorted[i].date,
          starts: starts,
          opens: scandalSpan(0).opens,
          closes: scandalSpan(0).closes,
        )) {
          window = sorted[i];
          careerId = career.id;
          nationId = career.nationId;
          break;
        }
      }
    }
    first = window;

    // Every match before the window played; the squad named for it.
    for (final f in await comp.cycleFixturesForNation(careerId, nationId)) {
      if (f.date.isBefore(first.date)) {
        await comp.recordResult(fixtureId: f.id, homeScore: 1, awayScore: 0);
      }
    }
    final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(nationId, saveSeed: career.rngSeed, careerId: careerId);
    squad = [for (final p in pool.take(23)) p.id];
    await c.read(squadRepositoryProvider).setCallUps(careerId, squad.toSet());
  });

  Future<void> callUpDone() async => c
      .read(competitionRepositoryProvider)
      .markDrawWatched(careerId, 0, 'callup:${first.id}');

  Future<PendingScandal?> pending([ProviderContainer? on]) {
    final container = on ?? c;
    container.invalidate(pendingScandalProvider(careerId));
    return container.read(pendingScandalProvider(careerId).future);
  }

  Future<HubEvent> nextEvent() async {
    c
      ..invalidate(nextEventProvider(careerId))
      ..invalidate(hubDataProvider(careerId));
    final sub = c.listen(nextEventProvider(careerId).future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  Future<({int morale, int board})> press() {
    c.invalidate(pressEffectProvider(careerId));
    return c.read(pressEffectProvider(careerId).future);
  }

  test(
    'offered only once the squad is named, before the first match',
    () async {
      expect(await pending(), isNull, reason: 'no squad named yet');
      await callUpDone();
      final s = (await pending())!;
      expect(squad, contains(s.playerId));
      expect(s.playerName, isNotEmpty);
      expect(s.window, first.date);
      expect(s.cycle, 0);
      // The same answer however often it is asked.
      expect(await pending(), s);
    },
  );

  test('the hub offers it as its own event', () async {
    await callUpDone();
    // Whatever the hub has to show before it (the budget, the draws), as the
    // story driver answers them; never a match.
    final driver = StoryDriver(c, careerId);
    var e = await nextEvent();
    for (var i = 0; i < 40 && e.kind != HubEventKind.scandal; i++) {
      expect(
        e.kind,
        isNot(anyOf(HubEventKind.match, HubEventKind.advance)),
        reason: 'played past the scandal',
      );
      if (e.kind == HubEventKind.friendlies) {
        // Declined: a friendly booked ahead of the window would be a window
        // of its own, with dice of its own.
        final plan = (await c.read(friendliesPlanProvider(careerId).future))!;
        await c
            .read(friendliesServiceProvider)
            .arrange(
              careerId,
              nationId: plan.playerNationId,
              cycle: plan.cycle,
              picks: const {},
              allWindows: plan.windows,
            );
      } else {
        await driver.step();
      }
      e = await nextEvent();
    }
    expect(e.kind, HubEventKind.scandal);
    expect(e.route, contains('/camp-scandal'));
    // The driver answers it like any other event, and it is gone.
    await driver.step();
    expect((await nextEvent()).kind, isNot(HubEventKind.scandal));
  });

  test('keep: morale -4 and board -3 this cycle, gone the next', () async {
    await callUpDone();
    final before = await press();
    final s = (await pending())!;
    await c.read(campScandalServiceProvider).keep(careerId, s);
    final after = await press();
    expect(after.morale - before.morale, CampScandal.keepMorale);
    expect(after.board - before.board, CampScandal.keepBoard);
    // He is still in the squad.
    expect(
      await c.read(squadRepositoryProvider).callUps(careerId),
      unorderedEquals(squad),
    );

    // The cycle turns: the cost does not linger, unlike what he SAID.
    await db.customStatement(
      'UPDATE careers SET cycle_pointer = cycle_pointer + 1 WHERE id = ?',
      [careerId],
    );
    c.invalidate(careerByIdProvider(careerId));
    expect(await press(), (morale: 0, board: 0));
  });

  test('send home: out of the squad, the XI and the quick-sim', () async {
    await callUpDone();
    final s = (await pending())!;
    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(nationId, saveSeed: 1, careerId: careerId);
    final incoming = pool.firstWhere((p) => !squad.contains(p.id)).id;
    await c
        .read(campScandalServiceProvider)
        .sendHome(careerId, s, replacement: s.finals ? null : incoming);

    final callUps = await c.read(squadRepositoryProvider).callUps(careerId);
    expect(callUps, isNot(contains(s.playerId)));
    if (!s.finals) expect(callUps, contains(incoming));
    final tactic = await c
        .read(tacticsRepositoryProvider)
        .tacticForCareer(careerId);
    expect(tactic?.lineup ?? const <int?>[], isNot(contains(s.playerId)));
    // No cost.
    expect(await press(), (morale: 0, board: 0));

    // The manager quick-sims the window's first match: he is not in it.
    await c.read(seasonServiceProvider).advance(careerId);
    final played = await db
        .customSelect(
          'SELECT player_id FROM player_ratings WHERE fixture_id = ?',
          variables: [Variable<int>(first.id)],
        )
        .map((r) => r.read<int>('player_id'))
        .get();
    expect(played, isNotEmpty, reason: 'the match was played');
    expect(played, isNot(contains(s.playerId)));
  });

  test('answered once: not offered again, even after a reload', () async {
    await callUpDone();
    final s = (await pending())!;
    await c.read(campScandalServiceProvider).sendHome(careerId, s);
    expect(await pending(), isNull);
    // A fresh container on the same save: the marker is what it reads.
    final reloaded = open();
    expect(await pending(reloaded), isNull);
    final records = await reloaded.read(campScandalsProvider(careerId).future);
    expect(records.single.playerId, s.playerId);
    expect(records.single.choice, ScandalChoice.sentHome);
    expect(records.single.kind, s.kind);
    // And the story is in the inbox, once.
    final keys = await c
        .read(competitionRepositoryProvider)
        .messageKeys(
          careerId,
        );
    expect(keys, contains(scandalMessageKey(0, s.playerId)));
  });

  test('played past without an answer: it counts as kept', () async {
    await callUpDone();
    final s = (await pending())!;
    await c.read(seasonServiceProvider).advance(careerId);
    final records = await c.read(campScandalsProvider(careerId).future);
    expect(records.single.choice, ScandalChoice.kept);
    expect(records.single.playerId, s.playerId);
    final answers = await c
        .read(careerRepositoryProvider)
        .pressAnswers(careerId, cycle: 0);
    expect(
      answers.where(
        (a) => a.questionKey == CampScandal.pressKeyOf(0, s.playerId),
      ),
      hasLength(1),
    );
  });

  test(
    'the feed: @IShowSlowness in English, the cameos only in Czech',
    () async {
      await callUpDone();
      final s = (await pending())!;
      await c.read(campScandalServiceProvider).keep(careerId, s);
      Future<List<String>> handles(String language) async {
        final container = open(language: language);
        final feed = await container.read(yFeedProvider(careerId).future);
        return [for (final p in feed.posts) p.handle];
      }

      final en = await handles('en');
      expect(en, contains('@IShowSlowness'));
      expect(en, isNot(contains('@TomasUjfaloci')));
      expect(en, isNot(contains('@PitomoLzimbersky')));
      expect(en, isNot(contains('@IvanHavir')));
      final cs = await handles('cs');
      expect(cs, contains('@IShowSlowness'));
      expect(cs, contains('@TomasUjfaloci'));
      expect(cs, contains('@PitomoLzimbersky'));
    },
  );

  test(
    'a man sent home is back for the next window if no squad was named',
    () async {
      await callUpDone();
      final s = (await pending())!;
      await c.read(campScandalServiceProvider).sendHome(careerId, s);
      final comp = c.read(competitionRepositoryProvider);
      final squads = c.read(squadRepositoryProvider);
      // Still his window: he stays out.
      await c.read(campScandalServiceProvider).restoreSentHome(careerId);
      expect(await squads.callUps(careerId), isNot(contains(s.playerId)));

      // The window is played out and the next one opens.
      final all = await comp.cycleFixturesForNation(careerId, nationId);
      final starts = CampScandal.windowStarts(all);
      final next = starts.firstWhere((d) => d.isAfter(first.date));
      for (final f in all.where((f) => f.date.isBefore(next))) {
        if (!f.hasResult) {
          await comp.recordResult(fixtureId: f.id, homeScore: 0, awayScore: 0);
        }
      }
      await c.read(campScandalServiceProvider).restoreSentHome(careerId);
      expect(await squads.callUps(careerId), contains(s.playerId));
    },
  );

  test('he never comes back over the squad limit', () async {
    await callUpDone();
    final s = (await pending())!;
    if (s.finals) return; // no replacement at a finals: nothing to test
    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(nationId, saveSeed: 1, careerId: careerId);
    final incoming = pool.firstWhere((p) => !squad.contains(p.id)).id;
    await c
        .read(campScandalServiceProvider)
        .sendHome(careerId, s, replacement: incoming);
    final comp = c.read(competitionRepositoryProvider);
    final all = await comp.cycleFixturesForNation(careerId, nationId);
    final next = CampScandal.windowStarts(
      all,
    ).firstWhere((d) => d.isAfter(first.date));
    for (final f in all.where((f) => f.date.isBefore(next))) {
      if (!f.hasResult) {
        await comp.recordResult(fixtureId: f.id, homeScore: 0, awayScore: 0);
      }
    }
    await c.read(campScandalServiceProvider).restoreSentHome(careerId);
    final callUps = await c.read(squadRepositoryProvider).callUps(careerId);
    expect(callUps, hasLength(23));
    expect(callUps, contains(incoming));
    expect(callUps, isNot(contains(s.playerId)));
  });

  test('a squad named for the next window without him is respected', () async {
    await callUpDone();
    final s = (await pending())!;
    await c.read(campScandalServiceProvider).sendHome(careerId, s);
    final comp = c.read(competitionRepositoryProvider);
    final all = await comp.cycleFixturesForNation(careerId, nationId);
    final next = all
        .where((f) => f.date.isAfter(first.date))
        .where(
          (f) => CampScandal.windowStarts(all).any((d) => d == f.date),
        )
        .reduce((a, b) => a.date.isBefore(b.date) ? a : b);
    for (final f in all.where((f) => f.date.isBefore(next.date))) {
      if (!f.hasResult) {
        await comp.recordResult(fixtureId: f.id, homeScore: 0, awayScore: 0);
      }
    }
    await comp.markDrawWatched(careerId, 0, 'callup:${next.id}');
    await c.read(campScandalServiceProvider).restoreSentHome(careerId);
    expect(
      await c.read(squadRepositoryProvider).callUps(careerId),
      isNot(contains(s.playerId)),
    );
  });

  test('a career bundle carries the decision', () async {
    await callUpDone();
    final s = (await pending())!;
    await c.read(campScandalServiceProvider).keep(careerId, s);
    final bundle = await CareerBundle.export(db, careerId);
    final imported = await CareerBundle.import(db, bundle);
    final records = await c.read(campScandalsProvider(imported).future);
    expect(records.single.choice, ScandalChoice.kept);
    expect(records.single.playerId, s.playerId);
    final answers = await c
        .read(careerRepositoryProvider)
        .pressAnswers(imported, cycle: 0);
    expect(
      answers.where((a) => a.tone == CampScandal.keepTone).single.moraleDelta,
      CampScandal.keepMorale,
    );
  });
}
