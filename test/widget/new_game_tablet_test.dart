import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/new_game_screen.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// Creating a save, held at a gate until the test lets it through, so the
/// manager can leave the page while it is being made. The gate is shut only
/// once the test arms it: [seedSave] makes its own save through the same
/// service first, and must not wait on it.
class _GatedCareers extends CareerService {
  // CareerService names its parameter `_ref`, which a subclass cannot match.
  // ignore: matching_super_parameters
  _GatedCareers(super.ref);

  Completer<void>? gate;

  /// When set, the next create throws (a disk full, a database gone) and
  /// clears the flag, so a retry goes through.
  bool throwOnce = false;

  @override
  Future<Result<Career>> create({
    required int nationId,
    required String managerName,
    int? rngSeed,
    bool countsTowardSlots = true,
  }) async {
    await gate?.future;
    if (throwOnce) {
      throwOnce = false;
      throw StateError('create failed');
    }
    return super.create(
      nationId: nationId,
      managerName: managerName,
      rngSeed: rngSeed,
      countsTowardSlots: countsTowardSlots,
    );
  }
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool gated = false,
  FormFactor formFactor = FormFactor.tablet,
}) async {
  final save = await seedSave(
    tester,
    formFactor: formFactor,
    overrides: [
      if (gated) careerServiceProvider.overrideWith(_GatedCareers.new),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.newGame}?nationId=${rivalNation.id}',
    size: size,
  );
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

Future<List<Career>> _careers(WidgetTester tester, SeededSave save) async {
  late List<Career> all;
  await tester.runAsync(() async {
    all = await save.container.read(careerRepositoryProvider).all();
  });
  return all;
}

Finder get _nameField => find.descendant(
  of: find.byKey(NewGameScreen.tabletLayoutKey),
  matching: find.byType(TextField),
);

/// Lets a save held at the gate through and pumps until the button's spinner
/// has gone, offstage ones too (under a pushed page `settle` does not see it).
Future<void> _release(WidgetTester tester, _GatedCareers careers) async {
  careers.gate!.complete();
  final spinner = find.byType(CircularProgressIndicator, skipOffstage: false);
  for (var i = 0; i < 400 && spinner.evaluate().isNotEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
  }
  expect(spinner, findsNothing, reason: 'the save finished being made');
  await settle(tester);
}

void main() {
  setUp(() => EditableText.debugDeterministicCursor = true);
  tearDown(() => EditableText.debugDeterministicCursor = false);

  for (final size in kTabletSizes) {
    testWidgets('the nation left, the name and Start right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NewGameScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final preview = tester.getRect(find.byType(NationPreview));
      expect(tester.getRect(_nameField).left, greaterThan(preview.right));
      expect(
        tester.widget<NationPreview>(find.byType(NationPreview)).nation.id,
        rivalNation.id,
      );
      expect(find.byKey(NewGameScreen.startKey), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Start career makes the save and opens its hub', (tester) async {
    final save = await _open(tester, kTabletSize);
    expect(
      [for (final c in await _careers(tester, save)) c.id],
      [
        save.careerId,
      ],
    );
    await tester.enterText(_nameField, 'Zola');
    await tester.tap(find.byKey(NewGameScreen.startKey));
    await settle(tester);
    final after = await _careers(tester, save);
    expect(after, hasLength(2));
    final made = after.firstWhere((c) => c.id != save.careerId);
    expect(made.managerName, 'Zola');
    expect(made.nationId, rivalNation.id);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${made.id}');
    // create() invalidated the saves list; re-read it before teardown.
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the half-typed name (Review Focus 3)', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    await tester.enterText(_nameField, 'Zola');
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(NewGameScreen.tabletLayoutKey), findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Zola',
    );
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(tester.widget<TextField>(_nameField).controller!.text, 'Zola');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a manager who leaves while the save is made stays where he '
      'went (Review Focus 4)', (tester) async {
    final save = await _open(tester, kTabletSize, gated: true);
    final careers = save.container.read(careerServiceProvider) as _GatedCareers
      ..gate = Completer<void>();
    await tester.enterText(_nameField, 'Zola');
    await tester.tap(find.byKey(NewGameScreen.startKey));
    await tester.pump();
    // The save is being made (the button spins). Settings pushed over the
    // page: the new game is still mounted under it. Not `settle` while the
    // gate is shut: the button's spinner is on purpose until it opens.
    unawaited(save.container.read(routerProvider).push(Routes.settings));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    // `router.state`, not the route information: a push does not report
    // through `routeInformationProvider`.
    final router = save.container.read(routerProvider);
    expect(router.state.uri.path, Routes.settings);
    // The save is made in the test's fake zone, so it only moves while frames
    // are pumped. Its spinner is under Settings, offstage, where `settle`
    // does not look: `_release` pumps on until that spinner has gone.
    await _release(tester, careers);
    expect(router.state.uri.path, Routes.settings);
    expect(await _careers(tester, save), hasLength(2), reason: 'still made');
    // create() invalidated the saves list while Settings was on show; no hub
    // was opened, and the write ran in the test's zone.
    await rebuildSavesInFakeZone(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  // Keyboard Done while the save is being made must not make a second one:
  // both the button and the field's Done call `_start`.
  for (final (label, formFactor, size) in [
    ('tablet', FormFactor.tablet, kTabletSize),
    ('phone', FormFactor.phone, kPhoneSize),
  ]) {
    testWidgets('Done after Start makes one save, $label', (tester) async {
      final save = await _open(
        tester,
        size,
        gated: true,
        formFactor: formFactor,
      );
      final careers =
          save.container.read(careerServiceProvider) as _GatedCareers
            ..gate = Completer<void>();
      expect(
        [for (final c in await _careers(tester, save)) c.id],
        [
          save.careerId,
        ],
      );
      await tester.enterText(find.byType(TextField), 'Zola');
      await tester.tap(find.text(enL.careerStartCareer));
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await _release(tester, careers);
      final after = await _careers(tester, save);
      expect(after, hasLength(2), reason: 'exactly one new save');
      final made = after.firstWhere((c) => c.id != save.careerId);
      expect(_uri(save).path, Routes.hub);
      expect(_uri(save).queryParameters['careerId'], '${made.id}');
      // The hub opened: it started the play clock and rebuilt the list.
      await stopPlayClock(tester, save);
      await tester.pumpWidget(const SizedBox());
    });
  }

  // A create that throws used to leave Start spinning for good: `_creating`
  // was only reset on the way out of a create that returned.
  for (final (label, formFactor, size) in [
    ('tablet', FormFactor.tablet, kTabletSize),
    ('phone', FormFactor.phone, kPhoneSize),
  ]) {
    testWidgets('a create that throws gives Start back, $label', (
      tester,
    ) async {
      final save = await _open(
        tester,
        size,
        gated: true,
        formFactor: formFactor,
      );
      // Armed after the save is seeded: seedSave creates through it too.
      final careers =
          save.container.read(careerServiceProvider) as _GatedCareers
            ..throwOnce = true;
      expect(await _careers(tester, save), hasLength(1));
      await tester.enterText(find.byType(TextField), 'Zola');
      final start = find.widgetWithText(PrimaryButton, enL.careerStartCareer);
      // The failure escapes `_start` as it would on a device (to the zone's
      // handler, which logs it); caught here so it does not fail the test.
      final errors = <Object>[];
      await runZonedGuarded(
        () => tester.tap(start),
        (e, _) => errors.add(e),
      );
      await settle(tester);
      expect(errors, [isA<StateError>()]);
      expect(careers.throwOnce, isFalse, reason: 'the create did throw');
      expect(await _careers(tester, save), hasLength(1));
      expect(
        tester.widget<PrimaryButton>(start).onPressed,
        isNotNull,
        reason: 'Start is live again',
      );
      await tester.tap(start);
      await settle(tester);
      final after = await _careers(tester, save);
      expect(after, hasLength(2), reason: 'the retry made exactly one save');
      final made = after.firstWhere((c) => c.id != save.careerId);
      expect(made.managerName, 'Zola');
      expect(_uri(save).path, Routes.hub);
      expect(_uri(save).queryParameters['careerId'], '${made.id}');
      await stopPlayClock(tester, save);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a resize while the save is made still opens its hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize, gated: true);
    final careers = save.container.read(careerServiceProvider) as _GatedCareers
      ..gate = Completer<void>();
    expect(await _careers(tester, save), hasLength(1));
    await tester.enterText(_nameField, 'Zola');
    await tester.tap(find.byKey(NewGameScreen.startKey));
    await tester.pump();
    // Not `settle` while the gate is shut: the spinner is on purpose.
    tester.view.physicalSize = const Size(900, 810);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(NewGameScreen.tabletLayoutKey), findsNothing);
    tester.view.physicalSize = kTabletSize;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(NewGameScreen.tabletLayoutKey), findsOneWidget);
    await _release(tester, careers);
    final after = await _careers(tester, save);
    expect(after, hasLength(2));
    final made = after.firstWhere((c) => c.id != save.careerId);
    expect(made.managerName, 'Zola');
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${made.id}');
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the keyboard up on the smallest tablet leaves Start reachable', (
    tester,
  ) async {
    const size = Size(1024, 768);
    await _open(tester, size);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.byKey(NewGameScreen.tabletLayoutKey), findsOneWidget);
    await tester.ensureVisible(find.byKey(NewGameScreen.startKey));
    await tester.pump();
    expect(tester.takeException(), isNull);
    final start = tester.getRect(find.byKey(NewGameScreen.startKey));
    expect(start.bottom, lessThanOrEqualTo(size.height - 300));
    expect(find.byKey(NewGameScreen.startKey).hitTestable(), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
