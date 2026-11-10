import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_news.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/messages/manager_changes_report.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../story/driver.dart';

ManagerMove _move(
  int nationId, {
  int? out,
  SpellEnd? why = SpellEnd.sacked,
  int? inc,
}) => (
  nationId: nationId,
  outgoingId: out ?? nationId * 10,
  why: why,
  incomingId: inc ?? nationId * 10 + 1,
  date: DateTime(2030, 7, 19),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() => AppLog.debugUse(null));

  test('nothing outside the four sets', () {
    final moves = [for (var n = 1; n <= 12; n++) _move(n)];
    final kept = ManagerNews.newsworthy(
      moves,
      // Nation 3's incoming man is tied to the player.
      tiedManagerIds: {31},
      myNations: {5},
      upcomingOpponents: {7},
      confTop10: {9},
    );
    expect(kept.map((m) => m.nationId).toSet(), {3, 5, 7});
    final none = ManagerNews.newsworthy(
      moves,
      tiedManagerIds: const {},
      myNations: const {},
      upcomingOpponents: const {},
      confTop10: const {},
    );
    expect(none, isEmpty);
  });

  test('beside a summary, only personal moves are news of their own', () {
    final moves = [for (var n = 1; n <= 12; n++) _move(n)];
    final kept = ManagerNews.newsworthy(
      moves,
      tiedManagerIds: {31},
      myNations: {5},
      upcomingOpponents: {7},
      confTop10: {9},
      maxRank: ManagerNews.personalRank,
    );
    expect(kept.map((m) => m.nationId).toSet(), {3, 5});
  });

  test('a summary lists every named change, and where a poached man went', () {
    final moves = <ManagerMove>[
      _move(1, out: 10, why: SpellEnd.poached, inc: 11),
      // Nation 2 sacked its man and took nation 1's.
      _move(2, out: 20, inc: 10),
      // Nation 3's man retired and nobody is in yet.
      (
        nationId: 3,
        outgoingId: 30,
        why: SpellEnd.retired,
        incomingId: null,
        date: DateTime(2030, 7, 19),
      ),
      // A vacancy filled.
      (
        nationId: 4,
        outgoingId: null,
        why: null,
        incomingId: 41,
        date: DateTime(2030, 7, 19),
      ),
      // Names nobody: not listed.
      (
        nationId: 5,
        outgoingId: null,
        why: null,
        incomingId: null,
        date: DateTime(2030, 7, 19),
      ),
    ];
    expect(ManagerNews.named(moves), hasLength(4));
    final rows = managerChangeRows(
      ManagerNews.named(moves),
      nations: {
        1: (code: 'AAA', name: 'Arvenia'),
        2: (code: 'BBB', name: 'Borlund'),
        3: (code: 'CCC', name: 'Castrova'),
        4: (code: 'DDD', name: 'Dalmir'),
      },
      managerNames: {
        10: 'Tomas Vrel',
        11: 'Ivo Marsk',
        20: 'Petr Hollan',
        30: 'Jan Dobrak',
        41: 'Emil Sorvan',
      },
    );
    final back = decodeManagerChanges(encodeManagerChanges(rows))!;
    expect(back, rows);
    expect(back[0].toNationId, 2);
    expect(back[0].toName, 'Borlund');
    expect(back[1].why, SpellEnd.sacked);
    expect(back[1].incomingName, 'Tomas Vrel');
    expect(back[2].incomingId, isNull);
    expect(back[3].outgoingId, isNull);
    expect(back[3].why, isNull);
    // Not a report: an ordinary body, or a transfer window.
    expect(decodeManagerChanges('The board are pleased.'), isNull);
    expect(decodeManagerChanges('#transfers/v4\n'), isNull);
  });

  test('never more than 3 per pass', () {
    final moves = [for (var n = 1; n <= 12; n++) _move(n)];
    final kept = ManagerNews.newsworthy(
      moves,
      tiedManagerIds: {110},
      myNations: {2},
      upcomingOpponents: {4, 6},
      confTop10: {1, 3, 5, 7, 8, 9},
    );
    expect(kept, hasLength(ManagerNews.maxPerPass));
    expect(ManagerNews.maxPerPass, 3);
    // The tied man first, then the player's nations, then his opponents.
    expect(kept.map((m) => m.nationId).toList(), [11, 2, 4]);
  });

  test('stored as meaning, rendered in cs', () {
    final cs = AppLocalizationsCs();
    final en = AppLocalizationsEn();
    for (final why in SpellEnd.values) {
      final msg = ManagerNews.message(
        _move(4, why: why),
        nation: 'Brazílie',
        outgoing: 'Jan Novák',
        incoming: 'Petr Svoboda',
      )!;
      final spec = decodeMessageSpec(
        encodeMessageSpec(title: msg.title, body: msg.body),
      );
      expect(spec, isNotNull, reason: '$why');
      final title = renderMsgPart(cs, spec!.title);
      expect(title, contains('Jan Novák'), reason: '$why');
      expect(title, isNot(renderMsgPart(en, spec.title)), reason: '$why');
      final body = renderMsgPart(cs, spec.body!);
      expect(body, contains('Petr Svoboda'), reason: '$why');
      expect(body, cs.mgrNewsAppointedBody('Brazílie', 'Petr Svoboda'));
    }
    final sacked = ManagerNews.message(
      _move(4),
      nation: 'Brazílie',
      outgoing: 'Jan Novák',
      incoming: 'Petr Svoboda',
    )!;
    expect(
      renderMsgPart(cs, sacked.title),
      cs.mgrNewsSacked('Brazílie', 'Jan Novák'),
    );
    // A vacancy filled with nobody leaving is an appointment.
    final appointed = ManagerNews.message(
      (
        nationId: 4,
        outgoingId: null,
        why: null,
        incomingId: 41,
        date: DateTime(2030),
      ),
      nation: 'Brazílie',
      outgoing: null,
      incoming: 'Petr Svoboda',
    )!;
    expect(
      renderMsgPart(cs, appointed.title),
      cs.mgrNewsAppointed('Brazílie', 'Petr Svoboda'),
    );
    expect(ManagerNews.dedupKey('wc:2030', 4), 'mgr:wc:2030:4');
    // Nobody left and nobody came: nothing to say, never "{nation} appoint ".
    final nobody = (
      nationId: 4,
      outgoingId: null,
      why: null,
      incomingId: null,
      date: DateTime(2030),
    );
    expect(
      ManagerNews.message(
        nobody,
        nation: 'Brazílie',
        outgoing: null,
        incoming: null,
      ),
      isNull,
    );
    expect(
      ManagerNews.newsworthy(
        [nobody],
        tiedManagerIds: const {},
        myNations: const {4},
        upcomingOpponents: const {},
        confTop10: const {},
      ),
      isEmpty,
    );
  });

  test('a pass files ONE summary of its changes, and only personal news '
      'beside it', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      kMatchViewModePrefsKey: 'timeline',
    });
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final c = storyContainer(db, 0);
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final d = await StoryDriver.start(c, 7);
    final careerId = d.careerId;
    final nations = await c.read(nationRepositoryProvider).forCareer(careerId);
    final rank = {for (final n in nations) n.id: n.ranking};
    final wcDate = DateTime(2030, 7, 19);
    // The better-ranked side loses every match: favourites miss briefs.
    final fixtures = await c
        .read(competitionRepositoryProvider)
        .allFixtures(careerId);
    await db.transaction(() async {
      for (final f in fixtures) {
        if (!f.date.isBefore(wcDate)) continue;
        final homeBetter =
            (rank[f.homeNationId] ?? 999) < (rank[f.awayNationId] ?? 999);
        final home = homeBetter ? 0 : 4;
        await db.customStatement(
          'UPDATE fixtures SET played = 1, home_score = ?, away_score = ? '
          'WHERE id = ?',
          [home, 4 - home, f.id],
        );
      }
    });
    final moves = await c
        .read(worldManagerServiceProvider)
        .afterFinals(
          careerId,
          key: 'wc:2030',
          scope: {for (final n in nations) n.id},
          date: wcDate,
        );
    expect(moves, isNotEmpty);
    final inbox = await c
        .read(competitionRepositoryProvider)
        .messages(careerId);
    final manager = [
      for (final m in inbox)
        if (m.category == 'manager') m,
    ];
    // A batch of changes is ONE summary message, listing every change that
    // names somebody, each man by id.
    final named = ManagerNews.named(moves);
    expect(named.length, greaterThanOrEqualTo(ManagerNews.summaryMin));
    final summaries = [
      for (final m in manager)
        if (decodeManagerChanges(m.body) != null) m,
    ];
    expect(summaries, hasLength(1));
    final rows = decodeManagerChanges(summaries.single.body)!;
    expect(rows, hasLength(named.length));
    expect(
      {for (final r in rows) r.nationId},
      {for (final m in named) m.nationId},
    );
    for (final r in rows) {
      expect(r.nationCode, isNotEmpty);
      if (r.outgoingId != null) expect(r.outgoingName, isNotEmpty);
      if (r.incomingId != null) expect(r.incomingName, isNotEmpty);
    }
    expect(
      renderMsgPart(
        AppLocalizationsEn(),
        decodeMessageSpec(summaries.single.spec)!.title,
      ),
      'Manager changes',
    );

    // Beside it, only what is personal: his own nation or a man tied to
    // him. The opponents and the confederation's top 10 are in the summary.
    final news = [
      for (final m in manager)
        if (!summaries.contains(m)) m,
    ];
    expect(news.length, lessThanOrEqualTo(3));
    final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
    for (final m in news) {
      expect(decodeMessageSpec(m.spec), isNotNull);
    }
    final keys = [
      for (final k
          in await c.read(competitionRepositoryProvider).messageKeys(careerId))
        if (k.startsWith('mgr:')) k,
    ];
    expect(keys, hasLength(manager.length));
    expect(keys, contains(ManagerNews.summaryDedupKey('wc:2030')));
    final moved = {for (final m in moves) m.nationId};
    for (final k in keys) {
      expect(k, startsWith('mgr:wc:2030:'));
      if (k.endsWith(':all')) continue;
      final nation = int.parse(k.split(':').last);
      expect(moved, contains(nation));
      // This save's player has led only his first nation, and has no ties
      // yet: anything personal is about that nation.
      expect(nation, career.nationId);
    }

    // Run again: the point has run, so it moves nobody and files nothing
    // twice.
    final again = await c
        .read(worldManagerServiceProvider)
        .afterFinals(
          careerId,
          key: 'wc:2030',
          scope: {for (final n in nations) n.id},
          date: wcDate,
        );
    expect(again, isEmpty);
    final after = await c
        .read(competitionRepositoryProvider)
        .messages(careerId);
    expect(
      after.where((m) => m.category == 'manager').length,
      manager.length,
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}
