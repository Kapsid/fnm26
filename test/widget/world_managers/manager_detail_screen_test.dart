import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_news.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/world_managers/manager_detail_screen.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../helpers/seeded_save.dart';

/// A manager of the save holding a job now, given an older spell at another
/// nation that ended when he was poached (on top of whatever history the
/// seeder wrote). Returns him and how many spells he has.
Future<(WorldManager, int)> _managerWithHistory(
  WidgetTester tester,
  SeededSave save,
) async {
  final m = await tester.runAsync(() async {
    await save.container
        .read(worldManagerServiceProvider)
        .ensureSeeded(save.careerId);
    final repo = save.container.read(worldManagerRepositoryProvider);
    final w = await repo.load(save.careerId);
    final now = w.spells.firstWhere((s) => s.current);
    final elsewhere = save.nations.firstWhere(
      (n) => n.id != now.nationId && n.id != save.nationId,
    );
    final from = DateTime(now.fromDate.year - 4, 7);
    await repo.apply(
      save.careerId,
      ManagerChanges(
        opened: [
          ManagerSpell(
            spellNo: w.nextSpellNo,
            managerId: now.managerId,
            nationId: elsewhere.id,
            fromDate: from,
            toDate: DateTime(now.fromDate.year - 1, 7),
            endReason: SpellEnd.poached,
            contractUntil: DateTime(from.year + 4, 7),
          ),
        ],
      ),
    );
    final spells = await repo.spellsOf(save.careerId, now.managerId);
    return (
      w.managers.firstWhere((x) => x.managerId == now.managerId),
      spells.length,
    );
  });
  return m!;
}

String _route(SeededSave save, int managerId) =>
    '${Routes.worldManager}?careerId=${save.careerId}&managerId=$managerId';

void main() {
  for (final lang in ['en', 'cs', 'de']) {
    testWidgets('phone 360x640: header, record and every spell ($lang)', (
      tester,
    ) async {
      final save = await seedSave(tester);
      final (m, spells) = await _managerWithHistory(tester, save);
      await pumpRoute(
        tester,
        save,
        _route(save, m.managerId),
        size: const Size(360, 640),
        locale: Locale(lang),
      );
      expect(tester.takeException(), isNull);
      final l = lookupAppLocalizations(Locale(lang));
      expect(find.byType(ManagerDetailScreen), findsOneWidget);
      expect(find.text(m.name), findsOneWidget);
      expect(find.byKey(ManagerDetailScreen.tabletLayoutKey), findsNothing);
      // Scroll the whole page through: nothing may overflow on the way.
      final list = find.byKey(ManagerDetailScreen.profileKey);
      await tester.scrollUntilVisible(
        find.byKey(ManagerDetailScreen.careerKey),
        200,
        scrollable: find.descendant(
          of: list,
          matching: find.byType(Scrollable),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(ManagerDetailScreen.spellRowKey),
        findsNWidgets(spells),
      );
      expect(find.text(l.mgrDetailInCharge), findsOneWidget);
      expect(find.text(l.mgrEndPoached), findsWidgets);
    });
  }

  testWidgets('phone: an unknown manager says so', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      _route(save, 999999),
      size: const Size(360, 640),
    );
    expect(tester.takeException(), isNull);
    expect(find.text(enL.mgrDetailNotFound), findsOneWidget);
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet: who he is left, his career right, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      final (m, spells) = await _managerWithHistory(tester, save);
      await pumpRoute(tester, save, _route(save, m.managerId), size: size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ManagerDetailScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final profile = tester.getRect(
        find.byKey(ManagerDetailScreen.profileKey),
      );
      final career = tester.getRect(find.byKey(ManagerDetailScreen.careerKey));
      expect(career.left, greaterThan(profile.right));
      expect(
        find.byKey(ManagerDetailScreen.spellRowKey),
        findsNWidgets(spells),
      );
      expect(find.text(m.name), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('manager news links to the manager it names', (tester) async {
    final save = await seedSave(tester);
    final (m, _) = await _managerWithHistory(tester, save);
    final nation = save.nations.firstWhere((n) => n.id != save.nationId).name;
    await tester.runAsync(
      () => save.container
          .read(competitionRepositoryProvider)
          .addTextMessage(
            l: enL,
            careerId: save.careerId,
            dedupKey: 'test:mgr-link',
            category: ManagerNews.category,
            title: MsgText(MsgKey.mgrNewsAppointed, [nation, m.name]),
            body: MsgText(MsgKey.mgrNewsAppointedBody, [nation, m.name]),
            year: 2026,
          ),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.messages}?careerId=${save.careerId}',
    );
    await tester.tap(find.text(enL.mgrNewsAppointed(nation, m.name)).first);
    await settle(tester);
    expect(find.byKey(MessageSheet.managerLinkKey), findsOneWidget);
    await tester.tap(find.byKey(MessageSheet.managerLinkKey));
    await settle(tester);
    expect(find.byType(ManagerDetailScreen), findsOneWidget);
    expect(find.byType(MessageSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('news names the man who left, then the man appointed, once each', () {
    const spec = (
      title: MsgText(MsgKey.mgrNewsSacked, ['Testland', 'A. Old']),
      body: MsgText(MsgKey.mgrNewsAppointedBody, ['Testland', 'B. New']),
      note: null,
    );
    expect(ManagerNews.namesIn(spec), ['A. Old', 'B. New']);
    const same = (
      title: MsgText(MsgKey.mgrNewsAppointed, ['Testland', 'B. New']),
      body: MsgText(MsgKey.mgrNewsAppointedBody, ['Testland', 'B. New']),
      note: null,
    );
    expect(ManagerNews.namesIn(same), ['B. New']);
  });
}
