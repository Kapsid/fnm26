import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/features/career/job_dossier_view.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/cycle_rollover_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The season with the roll recorded instead of run (see
/// cycle_rollover_tablet_test.dart): only the job asked for matters here.
class _RecordingSeason extends SeasonService {
  // ignore: use_super_parameters
  _RecordingSeason(Ref ref) : super(ref);

  final List<int?> rolledTo = [];

  @override
  Future<void> startNextCycle(
    int careerId, {
    int? switchToNationId,
    MsgPart? boardTitle,
    MsgPart? boardBody,
    FederationInvestment? nextInvestment,
  }) async {
    rolledTo.add(switchToNationId);
  }
}

Future<SeededSave> _open(
  WidgetTester tester, {
  Size size = kPhoneSize,
  FormFactor formFactor = FormFactor.phone,
  Locale locale = const Locale('en'),
}) async {
  final save = await seedSave(
    tester,
    formFactor: formFactor,
    overrides: [seasonServiceProvider.overrideWith(_RecordingSeason.new)],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.cycleRollover}?careerId=${save.careerId}',
    size: size,
    locale: locale,
  );
  return save;
}

Future<RolloverVerdict> _verdict(WidgetTester tester, SeededSave save) async {
  late RolloverVerdict v;
  await tester.runAsync(() async {
    final sub = save.container.listen(
      rolloverVerdictProvider(save.careerId).future,
      (_, _) {},
    );
    try {
      v = (await sub.read())!;
    } finally {
      sub.close();
    }
  });
  return v;
}

/// Reads [nationId]'s dossier the way the sheet does.
Future<JobDossier> _dossier(
  WidgetTester tester,
  SeededSave save,
  int nationId,
) async {
  late JobDossier d;
  await tester.runAsync(() async {
    final sub = save.container.listen(
      jobDossierProvider((careerId: save.careerId, nationId: nationId)).future,
      (_, _) {},
    );
    try {
      d = (await sub.read())!;
    } finally {
      sub.close();
    }
  });
  return d;
}

Future<void> _toOffers(WidgetTester tester) async {
  await tester.tap(find.byType(PrimaryButton).first);
  await settle(tester);
}

Future<void> _scout(WidgetTester tester, int nationId) async {
  final button = find.byKey(CycleRolloverScreen.scoutKey(nationId));
  // The board is a lazy list: the tile may not be built until scrolled to.
  await tester.scrollUntilVisible(
    button,
    120,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
  await settle(tester);
}

void main() {
  testWidgets('an offer opens a dossier, and taking the job from it picks it', (
    tester,
  ) async {
    final save = await _open(tester);
    final verdict = await _verdict(tester, save);
    // One of the smaller nations, the job a manager knows least about.
    final offer = verdict.offers.last.nation;
    final d = await _dossier(tester, save, offer.id);
    await _toOffers(tester);
    await _scout(tester, offer.id);
    expect(tester.takeException(), isNull);

    expect(d.squad.top, hasLength(5));
    for (final p in d.squad.top) {
      expect(find.text(p.name), findsWidgets, reason: p.name);
    }
    expect(
      find.descendant(
        of: find.byKey(JobDossierBody.ratingKey),
        matching: find.text('${d.squad.rating}'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(JobDossierBody.formKey), findsOneWidget);
    final report = tester.widget<Text>(find.byKey(JobDossierBody.reportKey));
    expect(report.data, isNotEmpty);
    expect(
      report.data,
      startsWith(
        d.squad.notes.isEmpty
            ? enL.jobDossierBalanced
            : jobDossierNoteText(enL, d.squad.notes.first, d.squad.star),
      ),
      reason: 'the read starts with its first line',
    );

    await tester.tap(find.byKey(JobDossierBody.takeKey));
    await settle(tester);
    expect(find.byType(JobDossierBody), findsNothing);
    // The job is picked: the button now takes it.
    await tester.tap(find.widgetWithText(PrimaryButton, enL.hubTakeTheJob));
    await settle(tester);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.hubBeginNextCycle));
    await settle(tester);
    expect(
      (save.container.read(seasonServiceProvider) as _RecordingSeason).rolledTo,
      [offer.id],
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a dossier closed without taking it picks nothing', (
    tester,
  ) async {
    final save = await _open(tester);
    final offer = (await _verdict(tester, save)).offers.first.nation;
    await _toOffers(tester);
    await _scout(tester, offer.id);
    expect(find.byType(JobDossierBody), findsOneWidget);
    await tester.tapAt(const Offset(20, 20)); // the barrier
    await settle(tester);
    expect(find.byType(JobDossierBody), findsNothing);
    expect(find.widgetWithText(PrimaryButton, enL.hubTakeTheJob), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the tablet scouts in a pane and takes the job from it', (
    tester,
  ) async {
    final save = await _open(
      tester,
      size: kTabletSize,
      formFactor: FormFactor.tablet,
    );
    final offer = (await _verdict(tester, save)).offers[1].nation;
    await _toOffers(tester);
    await _scout(tester, offer.id);
    expect(tester.takeException(), isNull);
    final pane = find.byType(JobDossierBody);
    expect(pane, findsOneWidget);
    // In the left column, where the verdict was.
    expect(
      tester.getRect(pane).right,
      lessThan(tester.getRect(find.text(enL.hubOffersOnTable)).left),
    );
    await tester.tap(find.byKey(JobDossierBody.takeKey));
    await settle(tester);
    expect(pane, findsNothing);
    expect(
      find.text(enL.boardObjectivesTitle.toUpperCase()),
      findsOneWidget,
      reason: 'the verdict is back',
    );
    await tester.tap(
      find.widgetWithText(PrimaryButton, enL.hubTakeTheJob).last,
    );
    await settle(tester);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    await settle(tester);
    expect(
      (save.container.read(seasonServiceProvider) as _RecordingSeason).rolledTo,
      [offer.id],
    );
    await tester.pumpWidget(const SizedBox());
  });

  for (final code in ['de', 'el', 'fi', 'hu', 'pt']) {
    testWidgets('$code: the dossier fits a 360 phone at 1.4', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final save = await _open(
        tester,
        size: const Size(360, 780),
        locale: Locale(code),
      );
      final verdict = await _verdict(tester, save);
      await _toOffers(tester);
      expect(tester.takeException(), isNull);
      for (final o in [verdict.offers.first, verdict.offers.last]) {
        await _scout(tester, o.nation.id);
        expect(tester.takeException(), isNull, reason: o.nation.name);
        final l = lookupAppLocalizations(Locale(code));
        await tester.ensureVisible(find.byKey(JobDossierBody.takeKey));
        await settle(tester);
        expect(tester.takeException(), isNull);
        expect(find.text(l.hubTakeTheJob), findsWidgets);
        await tester.tapAt(const Offset(20, 20));
        await settle(tester);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }
}
