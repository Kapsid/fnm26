import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/federation/national_stadiums_screen.dart';
import 'package:fnm/features/match/ground_card.dart';

import '../helpers/pump_app.dart';

/// Seats of the eight grounds: every level, ground 0 a level-3 one that
/// enlarges to 48,000 for €10M, ground 2 at the top, ground 4 at the bottom.
const List<int> _seats = [
  39000,
  30000,
  81000,
  20000,
  12000,
  45000,
  26000,
  16000,
];

/// A worked-on set: grounds at every level, one built and still under
/// construction, long names, and money for an upgrade but not a build.
NationalStadiumsView _view({
  bool window = true,
  int freeFunds = 12000000,
  bool building = true,
  String builtName = 'Kastel Arena Nova',
}) => NationalStadiumsView(
  careerId: 1,
  nationId: 20,
  cycle: 1,
  stadiums: [
    for (var i = 0; i < NationalStadiums.setSize; i++)
      NationalStadium(
        city: i == 0 ? 'Mönchengladbach-Rheydt' : 'City $i',
        name: i == 0
            ? 'Estadio Metropolitano Mönchengladbach-Rheydt'
            : 'Arena City $i',
        baseCapacity: _seats[i],
      ),
    NationalStadium(
      city: 'Kastel',
      name: builtName,
      baseCapacity: 73000,
      built: true,
      opensCycle: building ? 2 : 1,
    ),
  ],
  cities: const ['Berlin', 'Hamburg', 'Mönchengladbach-Rheydt'],
  window: window,
  freeFunds: freeFunds,
  income: 1500000,
  reputation: 3,
  resizedThisCycle: const {(city: 'City 1', built: false)},
  building: building,
);

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(360, 740),
  Locale locale = const Locale('en'),
  NationalStadiumsView? view,
  bool refuse = false,
  bool record = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.4;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final v = view ?? _view();
  await tester.pumpApp(
    const NationalStadiumsScreen(careerId: 1),
    locale: locale,
    overrides: [
      nationalStadiumsViewProvider(1).overrideWith((ref) async => v),
      if (refuse)
        nationalStadiumServiceProvider.overrideWith(_RefusingService.new),
      if (record)
        nationalStadiumServiceProvider.overrideWith(_RecordingService.new),
    ],
  );
  await tester.pumpAndSettle();
  // The screen opens on the map; these tests read the list.
  await tester.tap(
    find.descendant(
      of: find.byKey(NationalStadiumsScreen.viewToggleKey),
      matching: find.byIcon(Icons.view_list_rounded),
    ),
  );
  await tester.pumpAndSettle();
}

/// Scrolls the whole list through, so every card is built and laid out.
Future<void> _scrollThrough(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byKey(NationalStadiumsScreen.buildKey),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

/// Scrolls [finder] into view (the list builds lazily).
Future<void> _show(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    150,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final code in ['en', 'de', 'fi', 'hu', 'el', 'pt', 'cs', 'fil']) {
    testWidgets('fits a 360-wide phone at text 1.4 ($code)', (tester) async {
      await _pump(tester, locale: Locale(code));
      expect(tester.takeException(), isNull);
      await _scrollThrough(tester);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('and a tablet-wide window', (tester) async {
    await _pump(
      tester,
      size: const Size(1194, 834),
      locale: const Locale('de'),
    );
    await _scrollThrough(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an upgrade asks first, at its price', (tester) async {
    await _pump(tester);
    // Ground 0 is level 3 (39,000): to 48,000, €10M (€5M x 2.0 into level 4), affordable, in the
    // window.
    final up = find.byKey(NationalStadiumsScreen.upgradeKey(0));
    await _show(tester, up);
    expect(tester.widget<OutlinedButton>(up).onPressed, isNotNull);
    expect(find.text('Upgrade: €10M'), findsWidgets);
    await tester.tap(up);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.textContaining('to level 4 for €10M'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('a downsize asks first, says nothing comes back; the bottom '
      'level has none', (tester) async {
    await _pump(tester);
    final down = find.byKey(NationalStadiumsScreen.downsizeKey(0));
    await _show(tester, down);
    expect(tester.widget<TextButton>(down).onPressed, isNotNull);
    await tester.tap(down);
    await tester.pumpAndSettle();
    expect(find.textContaining('20,000 seats (level 2)'), findsOneWidget);
    expect(find.textContaining('Nothing is refunded'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(NationalStadiumsScreen.upgradeKey(4)),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(NationalStadiumsScreen.downsizeKey(4)), findsNothing);
    expect(find.textContaining('Earns '), findsWidgets);
  });

  testWidgets('upgraded this cycle, top level and under construction say so; '
      'a build under way blocks another', (tester) async {
    await _pump(tester);
    // Ground 1 was upgraded this cycle; its button is gone.
    await _show(tester, find.text('Rebuilt this cycle'));
    expect(find.byKey(NationalStadiumsScreen.upgradeKey(1)), findsNothing);
    expect(find.byKey(NationalStadiumsScreen.downsizeKey(1)), findsNothing);
    expect(find.text('Rebuilt this cycle'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Top level'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Top level'), findsOneWidget);
    await _scrollThrough(tester);
    expect(find.textContaining('Under construction'), findsOneWidget);
    expect(find.text('A stadium is already being built.'), findsOneWidget);
    final build = find.byKey(NationalStadiumsScreen.buildKey);
    expect(tester.widget<ButtonStyleButton>(build).onPressed, isNull);
  });

  testWidgets('outside the window: a record, with the price still shown', (
    tester,
  ) async {
    await _pump(tester, view: _view(window: false));
    expect(
      find.text(
        'Works are ordered at the start of a cycle, before the budget is set.',
      ),
      findsOneWidget,
    );
    final up = find.byKey(NationalStadiumsScreen.upgradeKey(0));
    await _show(tester, up);
    expect(tester.widget<OutlinedButton>(up).onPressed, isNull);
  });

  testWidgets('a refused order says so', (tester) async {
    await _pump(tester, refuse: true);
    await _show(tester, find.byKey(NationalStadiumsScreen.upgradeKey(0)));
    await tester.tap(find.byKey(NationalStadiumsScreen.upgradeKey(0)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(
      find.text('The order did not go through. Nothing was charged.'),
      findsOneWidget,
    );
  });

  group('naming a stadium', () {
    // A 32-character name in a long script: what the field allows at most.
    const longName = 'Εθνικό Ολυμπιακό Στάδιο Αθηνών Σ';

    testWidgets('a built ground shows its own name and offers a rename; seed '
        'grounds do not', (tester) async {
      await _pump(tester, view: _view(builtName: longName));
      await _scrollThrough(tester);
      expect(find.text(longName), findsOneWidget);
      expect(find.text('Kastel Arena Nova'), findsNothing);
      expect(
        find.byKey(NationalStadiumsScreen.renameKey(NationalStadiums.setSize)),
        findsOneWidget,
      );
      expect(find.byKey(NationalStadiumsScreen.renameKey(0)), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the order asks for a name, prefilled with the suggestion', (
      tester,
    ) async {
      _RecordingService.calls.clear();
      await _pump(
        tester,
        view: _view(building: false, freeFunds: 90000000),
        record: true,
      );
      await _scrollThrough(tester);
      await tester.tap(find.byKey(NationalStadiumsScreen.buildKey));
      await tester.pumpAndSettle();
      final field = find.byKey(NationalStadiumsScreen.nameFieldKey);
      expect(field, findsOneWidget);
      expect(
        tester.widget<TextField>(field).controller!.text,
        NationalStadiums.newStadiumName('Berlin'),
      );
      expect(find.text('Stadium name'), findsOneWidget);
      await tester.enterText(field, 'ราชมังคลา');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(_RecordingService.calls, ['build Berlin ราชมังคลา']);
    });

    testWidgets('a rename from the card', (tester) async {
      _RecordingService.calls.clear();
      await _pump(tester, record: true);
      await _scrollThrough(tester);
      final rename = find.byKey(
        NationalStadiumsScreen.renameKey(NationalStadiums.setSize),
      );
      await _show(tester, rename);
      await tester.tap(rename);
      await tester.pumpAndSettle();
      final field = find.byKey(NationalStadiumsScreen.nameFieldKey);
      expect(
        tester.widget<TextField>(field).controller!.text,
        'Kastel Arena Nova',
      );
      expect(tester.widget<TextField>(field).maxLength, StadiumName.maxLength);
      await tester.enterText(field, '新国立競技場');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(_RecordingService.calls, ['rename Kastel 新国立競技場']);
    });

    for (final code in ['de', 'fi', 'hu', 'el', 'pt']) {
      testWidgets('the name dialogs fit 360 wide at text 1.4 ($code)', (
        tester,
      ) async {
        await _pump(
          tester,
          locale: Locale(code),
          view: _view(
            building: false,
            freeFunds: 90000000,
            builtName: longName,
          ),
        );
        await _scrollThrough(tester);
        await tester.tap(find.byKey(NationalStadiumsScreen.buildKey));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(NationalStadiumsScreen.nameFieldKey),
          longName,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(
          find
              .descendant(
                of: find.byType(AlertDialog),
                matching: find.byType(TextButton),
              )
              .first,
        );
        await tester.pumpAndSettle();
        final rename = find.byKey(
          NationalStadiumsScreen.renameKey(NationalStadiums.setSize),
        );
        await _show(tester, rename);
        await tester.tap(rename);
        await tester.pumpAndSettle();
        expect(find.byKey(NationalStadiumsScreen.nameFieldKey), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('the ground card shows it', (tester) async {
      const stadium = NationalStadium(
        city: 'Kastel',
        name: longName,
        baseCapacity: 73000,
        built: true,
        opensCycle: 1,
      );
      final ground = Attendance.forFixture(
        fixture: Fixture(
          id: 1,
          careerId: 1,
          competitionId: 1,
          matchday: 1,
          date: DateTime(2030, 6, 20),
          homeNationId: 20,
          awayNationId: 30,
        ),
        neutral: false,
        tournamentHostIds: const [],
        citiesByNation: const {
          20: ['Kastel'],
        },
        seed: 1,
        homeGrounds: {20: (venue: stadium.venue, fillBonus: 0)},
      );
      expect(ground.stadium, longName);
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpApp(
        Scaffold(body: GroundCard(ground: ground)),
        locale: const Locale('de'),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining(longName), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

/// A service whose every order is refused (the funds moved, say).
class _RefusingService extends NationalStadiumService {
  _RefusingService(Ref ref) : super(ref);

  @override
  Future<bool> upgrade(int careerId, StadiumRef stadium) async => false;

  @override
  Future<bool> downsize(int careerId, StadiumRef stadium) async => false;

  @override
  Future<bool> build(int careerId, String city, {String? name}) async => false;

  @override
  Future<bool> rename(int careerId, String city, String name) async => false;
}

/// A service that records what it was asked and grants it.
class _RecordingService extends NationalStadiumService {
  _RecordingService(Ref ref) : super(ref);

  static final List<String> calls = [];

  @override
  Future<bool> build(int careerId, String city, {String? name}) async {
    calls.add('build $city $name');
    return true;
  }

  @override
  Future<bool> rename(int careerId, String city, String name) async {
    calls.add('rename $city $name');
    return true;
  }
}
