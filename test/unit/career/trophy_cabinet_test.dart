import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_summary_providers.dart';

import '../../helpers/test_database.dart';

/// The career trophy cabinet lists every title, how many times, and with which
/// nation — and it survives a change of nation, since a title is attributed to
/// the nation the manager held that cycle rather than their current one.
void main() {
  test('titles are grouped, counted, and tagged with the winning nation',
      () async {
    final db = createTestDatabase();
    final nations = (jsonDecode(
      File('assets/data/nations.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container.read(seedLoaderProvider).ensureSeeded();
    final byName = {for (final n in nations) n.name: n};
    final brazil = byName['Brazil']!;
    final argentina = byName['Argentina']!;
    final uruguay = byName['Uruguay']!;

    // A manager who managed Brazil in cycle 0 and Argentina in cycle 1.
    final career = (await container.read(careerServiceProvider).create(
          nationId: brazil.id,
          managerName: 'M',
        ))
        .valueOrNull!;
    final careers = container.read(careerRepositoryProvider);
    final comp = container.read(competitionRepositoryProvider);
    await careers.recordStint(career.id, 1, argentina.id);

    // Two World Cups (2030 Brazil, 2034 Argentina) and one continental title
    // with Brazil (2028).
    await comp.recordHonour(
      careerId: career.id,
      year: 2030,
      competition: 'World Championship',
      championId: brazil.id,
      runnerUpId: argentina.id,
    );
    await comp.recordHonour(
      careerId: career.id,
      year: 2034,
      competition: 'World Championship',
      championId: argentina.id,
      runnerUpId: brazil.id,
    );
    await comp.recordHonour(
      careerId: career.id,
      year: 2028,
      competition: 'South America Cup',
      championId: brazil.id,
      runnerUpId: argentina.id,
    );
    // A cup won that cycle by a nation the manager never managed — must NOT be
    // counted as the manager's (the manager held Argentina in cycle 1).
    await comp.recordHonour(
      careerId: career.id,
      year: 2032,
      competition: 'South America Cup',
      championId: uruguay.id,
      runnerUpId: brazil.id,
    );

    container.invalidate(careerSummaryProvider);
    final summary =
        await container.read(careerSummaryProvider(career.id).future);
    final titles = summary!.titles;

    // Two competitions won: World Cup (×2) and South America Cup (×1).
    final wc = titles.firstWhere((t) => t.competition == 'World Cup');
    expect(wc.count, 2);
    // Most-won first.
    expect(titles.first.competition, 'World Cup');

    // Each World Cup win carries the nation the manager held THAT cycle.
    final wc2030 = wc.wins.firstWhere((w) => w.year == 2030);
    final wc2034 = wc.wins.firstWhere((w) => w.year == 2034);
    expect(wc2030.nationName, 'Brazil');
    expect(
      wc2034.nationName,
      'Argentina',
      reason: 'the 2034 title belongs to the nation managed that cycle',
    );

    final copa = titles.firstWhere((t) => t.competition == 'South America Cup');
    expect(copa.count, 1, reason: '2032 was won by someone else');
    expect(copa.wins.single.year, 2028);
    expect(copa.wins.single.nationName, 'Brazil');
  }, timeout: const Timeout(Duration(minutes: 2)));
}
