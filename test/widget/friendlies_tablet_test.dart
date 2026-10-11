import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/friendlies/friendlies_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

/// Arranging friendlies, held at a gate until the test lets it through, so
/// the manager can leave the page while the games are saved. Counts the
/// calls, so a second write is seen.
class _GatedFriendlies extends FriendliesService {
  // The service names its field `_ref`; a super parameter cannot.
  // ignore: matching_super_parameters
  _GatedFriendlies(super.ref);

  final Completer<void> gate = Completer<void>();
  int calls = 0;

  /// The first write fails once let through, before anything is stored.
  bool failFirst = false;

  @override
  Future<void> arrange(
    int careerId, {
    required int nationId,
    required int cycle,
    required Map<DateTime, int> picks,
    required List<DateTime> allWindows,
  }) async {
    calls++;
    await gate.future;
    if (failFirst && calls == 1) throw StateError('the disk is full');
    return super.arrange(
      careerId,
      nationId: nationId,
      cycle: cycle,
      picks: picks,
      allWindows: allWindows,
    );
  }
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool gated = false,
  FormFactor formFactor = FormFactor.tablet,
  Override? plan,
}) async {
  final save = await seedSave(
    tester,
    formFactor: formFactor,
    overrides: [
      plan ?? fakeFriendliesOverride(),
      if (gated) friendliesServiceProvider.overrideWith(_GatedFriendlies.new),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.friendlies}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

/// The manager's friendlies on the calendar.
Future<List<Fixture>> _friendlies(WidgetTester tester, SeededSave save) async {
  late List<Fixture> all;
  await tester.runAsync(() async {
    all = await save.container
        .read(competitionRepositoryProvider)
        .fixturesForNation(save.careerId, save.nationId);
  });
  return [
    for (final f in all)
      if (f.round == Rounds.friendly) f,
  ];
}

Future<bool> _decided(
  WidgetTester tester,
  SeededSave save,
  DateTime window,
) async {
  late bool watched;
  await tester.runAsync(() async {
    watched = await save.container
        .read(competitionRepositoryProvider)
        .hasWatchedDraw(save.careerId, 0, friendlyWindowKey(window));
  });
  return watched;
}

/// The first side dealt to the first window: the head of the shortlist.
String get _firstOpponentCode => fakeFriendliesPlan().opponents.first.code;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the picks left, every window right, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final picks = tester.getRect(
        find.text(enL.friendliesYourGames.toUpperCase()),
      );
      expect(
        tester.getRect(find.byType(ColumnFlow)).left,
        greaterThan(picks.right),
      );
      expect(find.text(enL.friendliesFree), findsNWidgets(4));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('no gap: the Continue to the hub, as on the phone', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.friendlies}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsOneWidget);
    await tester.tap(
      find.widgetWithText(PrimaryButton, enL.friendliesContinue),
    );
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a pick and Confirm schedule the game the phone would', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final plan = fakeFriendliesPlan();
    final opponent = plan.opponents.first;
    final march = plan.windows.first;
    expect(await _friendlies(tester, save), isEmpty);
    expect(await _decided(tester, save, march), isFalse);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    // The picks panel names him; the button counts him.
    expect(find.text(opponent.name), findsWidgets);
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await settle(tester);
    final games = await _friendlies(tester, save);
    expect(games, hasLength(1));
    expect(games.single.date, march);
    expect(
      {games.single.homeNationId, games.single.awayNationId},
      {
        save.nationId,
        opponent.id,
      },
    );
    for (final w in plan.windows) {
      expect(await _decided(tester, save, w), isTrue, reason: '$w');
    }
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the picks (Review Focus 3)', (tester) async {
    await _open(tester, kTabletSize);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsNothing);
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsOneWidget);
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a manager who leaves while the games are saved stays where '
      'he went (Review Focus 4)', (tester) async {
    final save = await _open(tester, kTabletSize, gated: true);
    final service =
        save.container.read(friendliesServiceProvider) as _GatedFriendlies;
    final march = fakeFriendliesPlan().windows.first;
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await tester.pump();
    // The sidebar's ranking, while the save is held.
    save.container
        .read(routerProvider)
        .go('${Routes.ranking}?careerId=${save.careerId}');
    await settle(tester);
    service.gate.complete();
    await settle(tester);
    expect(await _decided(tester, save, march), isTrue, reason: 'still saved');
    expect(_uri(save).path, Routes.ranking);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a second tap on Confirm before the first lands books the '
      'game once', (tester) async {
    final save = await _open(tester, kTabletSize, gated: true);
    final service =
        save.container.read(friendliesServiceProvider) as _GatedFriendlies;
    expect(await _friendlies(tester, save), isEmpty);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    // Both taps in one frame: the button has not yet redrawn disabled.
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await tester.pump();
    service.gate.complete();
    await settle(tester);
    expect(service.calls, 1);
    expect(await _friendlies(tester, save), hasLength(1));
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a step that closes a picked window drops the pick before '
      'Confirm can book it (Task 2 carry-over)', (tester) async {
    final plan = fakeFriendliesPlan();
    final march = plan.windows.first;
    final june = plan.windows.last;
    // The plan the page reads, swapped by the "step" below, and a hold on
    // the re-read the step starts. The page watches the plan, so it is
    // always re-read before teardown and riverpod 2.6.1 is not tripped.
    var current = plan;
    Completer<void>? hold;
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [
        friendliesPlanProvider(kSeededCareerId).overrideWith((ref) async {
          await hold?.future;
          return current;
        }),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.friendlies}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(await _friendlies(tester, save), isEmpty);
    expect(await _decided(tester, save, march), isFalse);
    expect(await _decided(tester, save, june), isFalse);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    // The calendar moves past March: the plan the step's refresh re-reads
    // offers June alone. The step is a real one, committed as the top bar's
    // Continue commits it, so the page learns of it only through the
    // cascade's invalidation.
    current = FriendliesPlan(
      windows: [june],
      rivals: plan.rivals,
      reason: plan.reason,
      opponents: plan.opponents,
      nations: plan.nations,
      playerNationId: plan.playerNationId,
      cycle: plan.cycle,
    );
    hold = Completer<void>();
    await tester.runAsync(
      () => save.container.read(seasonServiceProvider).advance(save.careerId),
    );
    await tester.pump();
    // While the new plan is read the page still shows the old one, March
    // and its pick included: Confirm waits for it.
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await tester.pump();
    expect(await _friendlies(tester, save), isEmpty, reason: 'held');
    expect(await _decided(tester, save, march), isFalse, reason: 'held');
    hold.complete();
    await settle(tester);
    expect(find.text(enL.friendliesFree), findsNWidgets(2));
    expect(find.text(enL.friendliesConfirmCount(1)), findsNothing);
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await settle(tester);
    expect(await _friendlies(tester, save), isEmpty, reason: 'no past game');
    expect(await _decided(tester, save, march), isFalse);
    expect(await _decided(tester, save, june), isTrue);
    await tester.pumpWidget(const SizedBox());
  });
  // The plan offers up to six windows (the ceiling in friendliesPlanProvider).
  for (final size in kTabletSizes) {
    testWidgets('six windows fit, $size', (tester) async {
      final base = fakeFriendliesPlan();
      final six = FriendliesPlan(
        windows: [
          DateTime(2027, 3, 14),
          DateTime(2027, 6, 14),
          DateTime(2027, 9, 14),
          DateTime(2027, 10, 14),
          DateTime(2027, 11, 14),
          DateTime(2028, 3, 14),
        ],
        rivals: base.rivals,
        reason: base.reason,
        opponents: base.opponents,
        nations: base.nations,
        playerNationId: base.playerNationId,
        cycle: base.cycle,
      );
      await _open(
        tester,
        size,
        // No awaits, as fakeFriendliesOverride: see it for why.
        plan: friendliesPlanProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => six),
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsOneWidget);
      // Each window is free twice: on its card and in the picks panel.
      expect(find.text(enL.friendliesFree), findsNWidgets(12));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('on a phone too, a second tap on Confirm before the first '
      'lands books the game once', (tester) async {
    final save = await _open(
      tester,
      kPhoneSize,
      gated: true,
      formFactor: FormFactor.phone,
    );
    final service =
        save.container.read(friendliesServiceProvider) as _GatedFriendlies;
    expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsNothing);
    expect(await _friendlies(tester, save), isEmpty);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    final confirm = find.widgetWithText(
      PrimaryButton,
      enL.friendliesConfirmCount(1),
    );
    // Both taps in one frame: the button has not yet redrawn disabled.
    await tester.tap(confirm);
    await tester.tap(confirm);
    await tester.pump();
    service.gate.complete();
    await settle(tester);
    expect(service.calls, 1);
    expect(await _friendlies(tester, save), hasLength(1));
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a write that fails leaves Confirm working, and the retry '
      'books the game once', (tester) async {
    final save = await _open(tester, kTabletSize, gated: true);
    final service =
        save.container.read(friendliesServiceProvider) as _GatedFriendlies
          ..failFirst = true;
    final march = fakeFriendliesPlan().windows.first;
    expect(await _friendlies(tester, save), isEmpty);
    expect(await _decided(tester, save, march), isFalse);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    PrimaryButton button() =>
        tester.widget<PrimaryButton>(find.byKey(FriendliesScreen.confirmKey));
    // The write runs in the zone its tap started in. Guarding that zone
    // catches the failure, which the page leaves uncaught as before (in the
    // app it reaches the platform's error handler).
    Object? failure;
    await runZonedGuarded(
      () => tester.tap(find.byKey(FriendliesScreen.confirmKey)),
      (e, _) => failure = e,
    );
    await tester.pump();
    expect(button().onPressed, isNull, reason: 'off while saving');
    service.gate.complete();
    await settle(tester);
    expect(failure, isStateError);
    expect(await _friendlies(tester, save), isEmpty);
    expect(_uri(save).path, Routes.friendlies);
    expect(button().onPressed, isNotNull, reason: 'on again');
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await settle(tester);
    expect(service.calls, 2);
    final games = await _friendlies(tester, save);
    expect(games, hasLength(1));
    expect(games.single.date, march);
    expect(await _decided(tester, save, march), isTrue);
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });
}
