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
