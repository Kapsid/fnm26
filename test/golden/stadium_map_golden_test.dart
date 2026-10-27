import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/federation/national_stadiums_screen.dart';

import '../helpers/pump_app.dart';

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(
                File('assets/data/country_cities.json').readAsStringSync(),
              )
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

NationalStadiumsView _view(int nationId) {
  final all = NationalStadiums.forNation(
    nationId: nationId,
    seed: seedStadiums(nationId, _cities),
    works: const [],
  );
  return NationalStadiumsView(
    careerId: 1,
    nationId: nationId,
    cycle: 1,
    stadiums: NationalStadiums.nationalSet(all),
    cities: _cities[nationId]!,
    window: true,
    freeFunds: 90000000,
    income: 1200000,
    reputation: 0,
    resizedThisCycle: const {},
    building: false,
  );
}

/// The stadium map as it opens: Brazil on a phone, Portugal (with its
/// Madeira inset) on a tablet-wide window, and England while a new stadium
/// is being placed.
void main() {
  for (final (name, nation, size, picking) in [
    ('stadium_map_brazil_phone', 58, const Size(390, 844), false),
    ('stadium_map_portugal_tablet', 41, const Size(1194, 834), false),
    ('stadium_map_england_build_phone', 14, const Size(390, 844), true),
  ]) {
    testWidgets(name, (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final v = _view(nation);
      await tester.pumpApp(
        const RepaintBoundary(
          key: Key('stadiumMapGolden'),
          child: NationalStadiumsScreen(careerId: 1),
        ),
        overrides: [
          nationalStadiumsViewProvider(1).overrideWith((ref) async => v),
        ],
      );
      await tester.pumpAndSettle();
      if (picking) {
        await tester.tap(find.byKey(NationalStadiumsScreen.mapBuildKey));
        await tester.pumpAndSettle();
      }
      await expectLater(
        find.byKey(const Key('stadiumMapGolden')),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }
}
