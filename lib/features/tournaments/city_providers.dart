import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
