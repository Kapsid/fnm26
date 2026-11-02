import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/venues.dart';

/// Each nation's real cities (biggest first), for host-tournament venues.
/// Loaded from `assets/data/country_cities.json`, keyed by nation id.
final countryCitiesProvider = FutureProvider<Map<int, List<String>>>((
  ref,
) async {
  final raw =
      jsonDecode(
            await rootBundle.loadString('assets/data/country_cities.json'),
          )
          as Map<String, Object?>;
  return {
    for (final e in raw.entries)
      int.parse(e.key): (e.value! as List).cast<String>(),
  };
});

/// The extra towns and cities each nation can BUILD a stadium in, beyond its
/// seed cities (biggest first). Loaded from
/// `assets/data/stadium_build_cities.json` (tool/geo/fetch_build_cities.py).
///
/// A list of its own, used only as build candidates: [countryCitiesProvider]
/// feeds clubs' home cities, the seed grounds and host venues, and growing it
/// would move every existing save's grounds and clubs.
final stadiumBuildCitiesProvider = FutureProvider<Map<int, List<String>>>((
  ref,
) async {
  final raw =
      jsonDecode(
            // Uncached: the bundle keeps a loaded string's future for
            // good, and a big one read once is not worth holding (nor a
            // future a widget test left unfinished, which hung the next).
            await rootBundle.loadString(
              'assets/data/stadium_build_cities.json',
              cache: false,
            ),
          )
          as Map<String, Object?>;
  return {
    for (final e in raw.entries)
      int.parse(e.key): (e.value! as List).cast<String>(),
  };
});

/// Marks a cycle opened by 1.0.7 or later, whose finals are staged under
/// [VenueRules.scaled] (stored with the cycle's watched events: no schema
/// change). Written when a save is created and when a cycle starts. No venue
/// is stored, so a cycle already under way in an updated save has no mark
/// and keeps the grounds it was drawn with until it ends.
const String hostVenuesV2Kind = 'hostVenues2';

/// The venue rules of [careerId]'s finals in [cycle] (see
/// [hostVenuesV2Kind]).
Future<VenueRules> venueRulesFor(
  CompetitionRepository comp,
  int careerId,
  int cycle,
) async => await comp.hasWatchedDraw(careerId, cycle, hostVenuesV2Kind)
    ? VenueRules.scaled
    : VenueRules.original;
