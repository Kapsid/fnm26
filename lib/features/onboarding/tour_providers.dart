import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the manager has already been asked if he wants the walk through.
///
/// A property of the PERSON, not of a save: a second career does not make
/// somebody a beginner again. It therefore lives in preferences beside the
/// sound and language settings rather than in the database, which also means
/// it needs no schema bump and cannot be lost to a migration.
const String kTourOfferedKey = 'tour_offered_v1';

/// True once the offer has been made, whatever the answer was.
final tourOfferedProvider = StateProvider<bool>((ref) => true);

/// Which step the tour is on, or null when it is not running.
final tourStepProvider = StateProvider<int?>((ref) => null);

/// The save the tour is walking through.
///
/// Carried explicitly rather than read back off the router. Sniffing the
/// current route for a careerId looked tidy and failed silently: the overlay
/// sits above the Navigator, its builder does not necessarily re-run on a
/// route change, and a null id made it skip BOTH the navigation and the
/// measuring — so the tour became a popup that appeared over whatever screen
/// you happened to be on and lit nothing at all. Whoever starts the tour
/// knows which save it is; they say so.
final tourCareerProvider = StateProvider<int?>((ref) => null);

/// Reads the stored flag into [tourOfferedProvider].
///
/// Defaults to "already offered" until proven otherwise, so a slow read can
/// never flash the offer at somebody who has answered it before.
Future<void> loadTourOffered(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(tourOfferedProvider.notifier).state =
      prefs.getBool(kTourOfferedKey) ?? false;
}

/// Records that the question has been put, whatever the answer.
Future<void> markTourOffered(WidgetRef ref) async {
  ref.read(tourOfferedProvider.notifier).state = true;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(kTourOfferedKey, true);
}

/// Starts the tour at its first step, for [careerId].
void startTour(WidgetRef ref, int? careerId) {
  ref.read(tourCareerProvider.notifier).state = careerId;
  ref.read(tourStepProvider.notifier).state = 0;
}

/// Ends it, whether it was finished or skipped.
void endTour(WidgetRef ref) => ref.read(tourStepProvider.notifier).state = null;
