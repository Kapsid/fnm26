import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/condition_mark.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/features/tactics/nation_squad_tab.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart';

PlayerCondition _cond({
  FatigueState fatigue = FatigueState.fresh,
  int own = 0,
  int team = 1,
}) => (
  form: PlayerForm.steady,
  formRating: 0,
  fatigueState: fatigue,
  gamesInWindow: 0,
  overallDelta: own + team,
  personalDelta: own,
  clubStanding: null,
);

Player _p(int id, String name, PlayerPosition pos) => Player(
  id: id,
  nationId: 1,
  name: name,
  position: pos,
  age: 25,
  club: 'Club $id',
  attributes: const PlayerAttributes(physical: 70, technical: 70, stamina: 70),
);

const IconData _battery = Icons.battery_alert_rounded;

/// The page's own vertical scroll (the screens also hold sideways ones).
final Finder _vertical = find
    .byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    )
    .first;

/// Fatigue and the next-match shift at a glance (a player asked not to have
/// to open every profile). Calm by design: only a man who is tired or carries
/// a shift of his own gets a mark; the team-wide morale share (+1 here on
/// every man) never draws one.
void main() {
  group('squad tab (phone)', () {
    final data = NationSquadData(
      rows: [
        for (final (p, c) in [
          (
            _p(1, 'Arvo Kesting', PlayerPosition.st),
            _cond(fatigue: FatigueState.tired, own: -2),
          ),
          (_p(2, 'Bram Oyelaran', PlayerPosition.cm), _cond(own: 2)),
          (_p(3, 'Cosmin Valtteri', PlayerPosition.cb), _cond()),
          (
            _p(4, 'Dario Hellqvist', PlayerPosition.gk),
            _cond(fatigue: FatigueState.exhausted, own: -6),
          ),
          (
            _p(5, 'Emil Raskovar', PlayerPosition.lb),
            _cond(fatigue: FatigueState.ready, own: -1),
          ),
        ])
          (
            player: p,
            caps: 3,
            goals: 1,
            calledUp: true,
            starting: false,
            absence: null,
            condition: c,
          ),
      ],
      calledUp: 5,
      saveSeed: 7,
    );

    for (final locale in const [Locale('en'), Locale('cs')]) {
      testWidgets('${locale.languageCode}: only the affected are marked, '
          'and a 360x640 row still fits', (tester) async {
        tester.view
          ..physicalSize = const Size(360, 640)
          ..devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        await tester.pumpApp(
          const Scaffold(body: NationSquadTab(careerId: 1)),
          locale: locale,
          overrides: [
            nationSquadProvider(1).overrideWith((ref) async => data),
            absenceOutlookProvider(
              1,
            ).overrideWith((ref) async => const <int, AbsenceOutlook>{}),
            captainProvider(1).overrideWith((ref) async => null),
            captainMoraleProvider(1).overrideWith((ref) async => 0),
          ],
        );
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Emil Raskovar'),
          200,
          scrollable: _vertical,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('−2'), findsOneWidget);
        expect(find.text('+2'), findsOneWidget);
        expect(find.text('−6'), findsOneWidget);
        expect(find.text('−1'), findsOneWidget);
        // Tired and exhausted get the battery; "match legs" is only its −1.
        expect(find.byIcon(_battery), findsNWidgets(2));
        // The squad's shared +1 is nobody's mark.
        expect(find.text('+1'), findsNothing);
      });
    }
  });

  testWidgets('a fresh squad in ordinary form carries no marks at all', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: LineupConditionStrip(
          players: [_p(1, 'Arvo Kesting', PlayerPosition.st)],
          conditions: {1: _cond(team: 2)},
          starters: const {1},
        ),
      ),
    );
    expect(find.byKey(const ValueKey('lineupConditionStrip')), findsNothing);
    expect(find.byIcon(_battery), findsNothing);
  });

  /// The seeded save's squad with a tired starter, an exhausted starter and
  /// a bench man in form; everyone else fresh.
  Future<SeededSave> flaggedSave(
    WidgetTester tester, {
    FormFactor formFactor = FormFactor.phone,
  }) => seedSave(
    tester,
    formFactor: formFactor,
    overrides: [
      squadConditionProvider(kSeededCareerId).overrideWith((ref) async {
        final data = (await ref.watch(
          tacticDataProvider(kSeededCareerId).future,
        ))!;
        final xi = data.tactic.lineup.whereType<int>().toList();
        final bench = [
          for (final p in data.pool)
            if (!xi.contains(p.id)) p.id,
        ];
        return {
          for (final p in data.pool) p.id: _cond(),
          xi[0]: _cond(fatigue: FatigueState.tired, own: -2),
          xi[1]: _cond(fatigue: FatigueState.exhausted, own: -6),
          bench.first: _cond(own: 2),
        };
      }),
    ],
  );

  testWidgets('phone line-up: the condition strip under the pitch, in '
      '360x640', (tester) async {
    final save = await flaggedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: const Size(360, 640),
    );
    final strip = find.byKey(const ValueKey('lineupConditionStrip'));
    await tester.scrollUntilVisible(strip, 200, scrollable: _vertical);
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(of: strip, matching: find.text('−2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: strip, matching: find.text('−6')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: strip, matching: find.text('+2')),
      findsOneWidget,
    );
    // Starters lead the strip.
    final first = tester.getTopLeft(
      find.descendant(of: strip, matching: find.text('−6')),
    );
    final bench = tester.getTopLeft(
      find.descendant(of: strip, matching: find.text('+2')),
    );
    expect(
      first.dy < bench.dy || (first.dy == bench.dy && first.dx < bench.dx),
      isTrue,
    );
    // Nothing on the pitch itself.
    expect(
      find.descendant(
        of: find.byType(TacticsPitch),
        matching: find.byIcon(_battery),
      ),
      findsNothing,
    );
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet line-up at ${size.width.toInt()}: starters on the '
        'strip, the bench on its chips', (tester) async {
      final save = await flaggedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      final strip = find.byKey(const ValueKey('lineupConditionStrip'));
      expect(strip, findsOneWidget);
      expect(
        find.descendant(of: strip, matching: find.text('−6')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: strip, matching: find.text('+2')),
        findsNothing,
        reason: 'the bench man is marked on his chip, not again here',
      );
      expect(
        find.descendant(
          of: find.byType(BenchChip),
          matching: find.text('+2'),
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('tablet squad: the overview carries the marks', (tester) async {
    final save = await flaggedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(ConditionMark), findsWidgets);
    expect(find.text('−6'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
