import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/nations/nation_vitrine_providers.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';

import '../helpers/seeded_save.dart';

/// Review Focus 3. A tablet's top bar runs the sim while a competition screen
/// is on show, and that screen's provider is kept alive by being watched. One
/// step must hand every one of them a fresh read.
void main() {
  testWidgets('a step refreshes every competition screen a tablet keeps '
      'on show', (tester) async {
    final save = await seedSave(tester);
    final id = save.careerId;
    final c = save.container;
    final providers = <String, ProviderListenable<Future<Object?>>>{
      'tournaments': tournamentsOverviewProvider(id).future,
      'cup': cupDetailProvider(id).future,
      'continental': continentalDetailProvider((
        careerId: id,
        confederation: Confederation.europe,
      )).future,
      'nationsCup': nationsCupProvider((
        careerId: id,
        confederation: null,
      )).future,
      'clash': continentalClashProvider(id).future,
      'playoff': intercontinentalPlayoffProvider(id).future,
      'results': resultsProvider(id).future,
      'wcHost': wcHostThemeProvider(id).future,
      'continentalHost': continentalHostThemeProvider(id).future,
      'vitrine': nationVitrineProvider((
        careerId: id,
        nationId: save.nationId,
      )).future,
    };
    // The listeners are the screens on show. They are opened inside the real
    // async zone, so the reads they start are not stranded on fake time.
    final subs = <String, ProviderSubscription<Future<Object?>>>{};
    addTearDown(() {
      for (final s in subs.values) {
        s.close();
      }
    });
    final before = <String, Future<Object?>>{};
    await tester.runAsync(() async {
      for (final e in providers.entries) {
        subs[e.key] = c.listen<Future<Object?>>(e.value, (_, _) {});
        before[e.key] = subs[e.key]!.read();
        await before[e.key];
        // Sanity: with no step in between, the same read comes back.
        expect(
          identical(subs[e.key]!.read(), before[e.key]),
          isTrue,
          reason: e.key,
        );
      }
      await c.read(seasonServiceProvider).advance(id);
      for (final e in subs.entries) {
        final after = e.value.read();
        expect(
          identical(after, before[e.key]),
          isFalse,
          reason: '${e.key} kept its pre-step data',
        );
        // Let the fresh read finish inside the real-async zone, so no
        // database work is left pending when the test ends.
        await after;
      }
    });
  });
}
