import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

/// A whole cycle of a mid-ranked European side, holding every preview as it
/// comes due: one per campaign, each before that campaign's first match, and
/// every target it put on the record judged by the end.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a cycle brings one preview per campaign, each judged', () async {
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
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

    // Europe's 19th side on this seed: no host, qualifies for both finals.
    final europe =
        nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: europe[18].id, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
    final comp = container.read(competitionRepositoryProvider);
    final season = container.read(seasonServiceProvider);
    final press = container.read(conferenceServiceProvider);
    await comp.markDrawWatched(career.id, career.cyclePointer, budgetSetupKind);

    final held = <PreviewCampaign>[];
    var last = DateTime(1900);
    for (var i = 0; i < 2000; i++) {
      container
        ..invalidate(previewDueProvider)
        ..invalidate(pendingConferenceProvider);
      final due = await container.read(previewDueProvider(career.id).future);
      if (due != null) {
        // The opener has not been played, and nothing of its campaign has.
        final mine = await comp.cycleFixturesForNation(
          career.id,
          career.nationId,
        );
        expect(due.fixture.hasResult, isFalse);
        expect(
          mine.where(
            (f) =>
                f.hasResult && PreviewCampaign.ofRound(f.round) == due.campaign,
          ),
          isEmpty,
        );
        await press.openPreview(career.id, due);
        final c = (await container.read(
          pendingConferenceProvider(career.id).future,
        ))!;
        expect(c.row.reason, ConferenceReason.preview);
        final beats = ConferenceBuilder.previewBeats(c.facts);
        for (final (index, beat) in beats.indexed) {
          final answer = index > 0
              ? AnswerKind.deflect
              : due.campaign.isQualifying
              ? AnswerKind.promiseQualify
              : AnswerKind.matchBrief;
          await press.answer(career.id, c, index, beat, answer);
        }
        await press.finish(career.id, c.row.id);
        held.add(due.campaign);
        container.invalidate(previewDueProvider);
        expect(
          await container.read(previewDueProvider(career.id).future),
          isNull,
          reason: 'held once, never offered again',
        );
      }
      if (await comp.worldChampion(career.id) != null) break;
      await season.advance(career.id);
      final hub = await container.read(hubDataProvider(career.id).future);
      if (hub == null || !hub.career.inGameDate.isAfter(last)) break;
      last = hub.career.inGameDate;
    }

    expect(held, [
      PreviewCampaign.continentalQualifying,
      PreviewCampaign.continentalFinals,
      PreviewCampaign.worldQualifying,
      PreviewCampaign.worldFinals,
    ]);

    final targets = [
      for (final s
          in await container
              .read(careerRepositoryProvider)
              .statements(career.id))
        if (s.kind == StatementKind.target) s,
    ];
    expect(targets, hasLength(4));
    // Both qualifying promises were kept: the side reached both finals.
    expect(targets[0].status, StatementStatus.kept);
    expect(targets[2].status, StatementStatus.kept);
    // The finals targets are judged once the run is over.
    expect(targets[1].status, isNot(StatementStatus.open));
  }, timeout: const Timeout(Duration(minutes: 20)));
}
