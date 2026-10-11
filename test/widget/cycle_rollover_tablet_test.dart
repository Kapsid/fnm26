import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/cycle_rollover_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The season as the rollover screen uses it, with the roll itself recorded
/// instead of run: a real roll needs a finished cycle (`startNextCycle`
/// returns untouched mid-cycle), far too long a drive for a widget test. The
/// roll can be held at [gate], to leave the page while it runs.
class _RecordingSeason extends SeasonService {
  // A positional forward, not `super.ref`: the real constructor's parameter
  // is the private `this._ref`, and a super parameter named otherwise trips
  // `matching_super_parameters`.
  // ignore: use_super_parameters
  _RecordingSeason(Ref ref) : super(ref);

  /// Every roll asked for: the save, the job (null: stay), and the board's
  /// verdict carried into the new cycle's opening message.
  final List<(int, int?, MsgPart?, MsgPart?)> rolls = [];

  /// The job each roll was asked for (null: stay).
  List<int?> get rolledTo => [for (final r in rolls) r.$2];

  /// Armed by a test AFTER [seedSave], so nothing the seeding does waits on it.
  Completer<void>? gate;

  /// Holds the paywall check, the await before the button turns busy. On a
  /// device that read is real I/O; the in-memory test database answers it
  /// within the tap, which would hide the gap a second tap can land in.
  Completer<void>? checkGate;

  @override
  Future<bool> trialBlocksNextCycle(int careerId) async {
    await checkGate?.future;
    return super.trialBlocksNextCycle(careerId);
  }

  @override
  Future<void> startNextCycle(
    int careerId, {
    int? switchToNationId,
    MsgPart? boardTitle,
    MsgPart? boardBody,
    FederationInvestment? nextInvestment,
  }) async {
    await gate?.future;
    rolls.add((careerId, switchToNationId, boardTitle, boardBody));
  }
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  FormFactor formFactor = FormFactor.tablet,
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
  );
  return save;
}

/// The top-most route, a pushed one included.
Uri _uri(SeededSave save) => save.container.read(routerProvider).state.uri;

_RecordingSeason _season(SeededSave save) =>
    save.container.read(seasonServiceProvider) as _RecordingSeason;

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

Future<void> _continue(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(PrimaryButton, enL.hubContinue));
  await settle(tester);
}

/// The roll button, on either layout.
Finder get _beginButton =>
    find.widgetWithText(PrimaryButton, enL.hubBeginNextCycle);

/// Opens the held roll and pumps until its work, which runs in the test's
/// fake zone, is done (offstage spinners included), then settles.
Future<void> _release(WidgetTester tester, _RecordingSeason season) async {
  season.gate!.complete();
  final spinner = find.byType(CircularProgressIndicator, skipOffstage: false);
  for (var i = 0; i < 40; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
  }
  for (var i = 0; i < 400 && spinner.evaluate().isNotEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
  }
  await settle(tester);
}

/// Asserts the one roll recorded was for [save], to [job], carrying
/// [verdict]'s headline and detail. MsgPart has no value equality, so the
/// two are compared as the words they make.
void _expectRolled(
  SeededSave save,
  int? job,
  RolloverVerdict verdict,
) {
  final rolls = _season(save).rolls;
  expect(rolls, hasLength(1));
  final (careerId, switchTo, title, body) = rolls.single;
  expect(careerId, save.careerId);
  expect(switchTo, job);
  expect(title, isNotNull);
  expect(body, isNotNull);
  expect(renderMsgPart(enL, title!), renderMsgPart(enL, verdict.headline));
  expect(renderMsgPart(enL, body!), renderMsgPart(enL, verdict.detail));
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('every step in two columns, a way out on each, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      // Step 0: the trophy left, Continue right. The seeded world carries
      // its 2026 history, so there is a champion to crown.
      final champions = find.text(enL.hubWorldChampionsYear(2026));
      expect(champions, findsOneWidget);
      expect(
        tester
            .getRect(find.widgetWithText(PrimaryButton, enL.hubContinue))
            .left,
        greaterThan(tester.getRect(champions).right),
      );
      expect(find.text(enL.hubBackToSaves), findsOneWidget);
      // Step 1: the verdict left, the jobs right.
      await _continue(tester);
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.text(enL.hubOffersOnTable)).left,
        greaterThan(
          tester
              .getRect(find.text(enL.boardObjectivesTitle.toUpperCase()))
              .right,
        ),
      );
      expect(find.text(enL.hubBackToSaves), findsOneWidget);
      // Step 2: the money left, the roll right.
      await tester.tap(find.byType(PrimaryButton).last);
      await settle(tester);
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.byKey(CycleRolloverScreen.beginKey)).left,
        greaterThan(tester.getRect(find.text(enL.hubFederationFinances)).right),
      );
      expect(find.text(enL.hubBackToSaves), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('the job picked is the job the save rolls to', (tester) async {
    final save = await _open(tester, kTabletSize);
    final verdict = await _verdict(tester, save);
    final offer = verdict.offers[1].nation;
    await _continue(tester);
    // The last match is the tile in the right-hand column (the verdict is
    // built first, on the left).
    await tester.tap(find.text(offer.name).last);
    await settle(tester);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.hubTakeTheJob));
    await settle(tester);
    expect(_season(save).rolledTo, isEmpty);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    await settle(tester);
    _expectRolled(save, offer.id, verdict);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${save.careerId}');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the step and the job (Review Focus 3)', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final offer = (await _verdict(tester, save)).offers[0].nation;
    await _continue(tester);
    // The last match is the tile in the right-hand column (the verdict is
    // built first, on the left).
    await tester.tap(find.text(offer.name).last);
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsNothing);
    expect(
      find.widgetWithText(PrimaryButton, enL.hubTakeTheJob),
      findsOneWidget,
    );
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsOneWidget);
    expect(
      find.widgetWithText(PrimaryButton, enL.hubTakeTheJob),
      findsOneWidget,
    );
    // The job carried both ways is the job rolled to.
    await tester.tap(find.widgetWithText(PrimaryButton, enL.hubTakeTheJob));
    await settle(tester);
    expect(_season(save).rolledTo, isEmpty);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    await settle(tester);
    expect(_season(save).rolledTo, [offer.id]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize while the world rolls still opens the hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final season = _season(save)..gate = Completer<void>();
    await _continue(tester);
    await tester.tap(find.byType(PrimaryButton).last);
    await settle(tester);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    await settle(tester);
    expect(find.text(enL.hubStarting), findsOneWidget);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsNothing);
    expect(find.text(enL.hubStarting), findsOneWidget, reason: 'still busy');
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsOneWidget);
    expect(season.rolledTo, isEmpty);
    await _release(tester, season);
    expect(season.rolledTo, [null]);
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a manager who leaves mid-roll stays where he went '
      '(Review Focus 4)', (tester) async {
    final save = await _open(tester, kTabletSize);
    final season = _season(save)..gate = Completer<void>();
    await _continue(tester);
    await tester.tap(find.byType(PrimaryButton).last);
    await settle(tester);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    // Let the paywall check pass and the roll reach its gate: leaving any
    // sooner would leave before the roll began.
    await settle(tester);
    expect(find.text(enL.hubStarting), findsOneWidget);
    expect(season.rolledTo, isEmpty);
    save.container.read(routerProvider).go(Routes.saves);
    await settle(tester);
    expect(_uri(save).path, Routes.saves);
    await _release(tester, season);
    expect(season.rolledTo, [null], reason: 'the roll still ran');
    expect(_uri(save).path, Routes.saves);
    await tester.pumpWidget(const SizedBox());
  });

  // A page pushed over the rollover keeps it mounted, so this is the case the
  // route check (not `mounted`) decides.
  testWidgets('a page pushed over a roll stays on top when it lands', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final season = _season(save)..gate = Completer<void>();
    await _continue(tester);
    await tester.tap(find.byType(PrimaryButton).last);
    await settle(tester);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    await settle(tester);
    expect(find.text(enL.hubStarting), findsOneWidget);
    final router = save.container.read(routerProvider);
    unawaited(router.push(Routes.settings));
    await settle(tester);
    expect(router.state.uri.path, Routes.settings);
    expect(season.rolledTo, isEmpty);
    await _release(tester, season);
    expect(season.rolledTo, [null], reason: 'the roll still ran');
    expect(router.state.uri.path, Routes.settings);
    await tester.pumpWidget(const SizedBox());
  });

  // A second tap landing before the first has passed the paywall check must
  // not roll the world a second time. Both layouts share `_begin`.
  for (final (label, formFactor, size) in [
    ('tablet', FormFactor.tablet, kTabletSize),
    ('phone', FormFactor.phone, kPhoneSize),
  ]) {
    testWidgets('a double tap on the roll rolls once, $label', (tester) async {
      final save = await _open(tester, size, formFactor: formFactor);
      final verdict = await _verdict(tester, save);
      await _continue(tester);
      await tester.tap(find.byType(PrimaryButton).last);
      await settle(tester);
      final season = _season(save)..checkGate = Completer<void>();
      expect(season.rolledTo, isEmpty);
      // The second tap lands while the first is still at the paywall check,
      // before the button has turned busy: it is still live.
      await tester.tap(_beginButton);
      await tester.pump();
      expect(find.text(enL.hubStarting), findsNothing);
      await tester.tap(_beginButton);
      await tester.pump();
      season.checkGate!.complete();
      await settle(tester);
      _expectRolled(save, null, verdict);
      expect(_uri(save).path, Routes.hub);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
