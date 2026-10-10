import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/squad/training_camp.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import 'competition_fixtures.dart';
import 'seeded_save.dart';

// Fakes for the federation, manager and Y screens: the states a fresh save
// does not reach on its own (a camp to choose, an offer to decide, points to
// spend, a feed with something in it).

/// The best-ranked nations after the manager's, [count] of them: hosts for a
/// base-camp decision.
List<int> campHosts(int count) => [
  for (final n in fieldOf(seededNationId, count + 1).skip(1)) n.id,
];

/// A World Championship base-camp decision in [hostIds]' countries, the first
/// the primary host, nothing chosen yet. Cycle 0, as the seeded save is. A
/// solo host offers all its camps, co-hosts fewer each, as the provider does.
TrainingCampPlan fakeCampPlan(List<int> hostIds) {
  final byId = realNationsById;
  final perHost = switch (hostIds.length) {
    <= 1 => TrainingCamps.count,
    2 => 3,
    _ => 2,
  };
  final primary = byId[hostIds.first]!;
  return TrainingCampPlan(
    tournament: 'GROUP',
    competition: 'World Championship',
    hostId: primary.id,
    hostName: primary.name,
    hostCode: primary.code,
    hostNames: [for (final id in hostIds) byId[id]!.name],
    options: [
      for (final id in hostIds)
        for (final camp in TrainingCamps.forHost(
          hostId: id,
          cities: _fakeCities(byId[id]!.name),
        ).take(perHost))
          (
            hostId: id,
            hostName: byId[id]!.name,
            hostCode: byId[id]!.code,
            camp: camp,
          ),
    ],
    cycle: 0,
    chosen: null,
  );
}

/// Regions named after their country, so co-hosts' camps never share a
/// name (the built-in fallback regions are the same for every country).
List<String> _fakeCities(String nation) => [
  '$nation North',
  '$nation South',
  '$nation East',
  '$nation West',
  '$nation Central',
];

/// Puts a naturalisation offer on [save]: the best player of the best-ranked
/// nation after the manager's, asking to switch this cycle.
Future<({int playerId, int sourceNationId})> offerNaturalization(
  WidgetTester tester,
  SeededSave save,
) async {
  late ({int playerId, int sourceNationId}) out;
  await tester.runAsync(() async {
    final source = fieldOf(save.nationId, 2)[1];
    final pool = await save.container
        .read(playerRepositoryProvider)
        .byNation(
          source.id,
          agingYears: CareerService.agingYears(save.career),
          saveSeed: save.career.rngSeed,
        );
    final best = pool.reduce((a, b) => a.overall >= b.overall ? a : b);
    await save.container
        .read(careerRepositoryProvider)
        .addNaturalizationOffer(
          careerId: save.careerId,
          playerId: best.id,
          sourceNationId: source.id,
          cycle: save.career.cyclePointer,
        );
    out = (playerId: best.id, sourceNationId: source.id);
  });
  return out;
}

/// Marks this cycle's budget as set, as confirming it does, so the hub's
/// next event is whatever comes after the budget.
Future<void> markBudgetSet(WidgetTester tester, SeededSave save) async {
  await tester.runAsync(
    () => save.container
        .read(competitionRepositoryProvider)
        .markDrawWatched(
          save.careerId,
          save.career.cyclePointer,
          budgetSetupKind,
        ),
  );
}

/// The manager's page as the real provider builds it from the stored career,
/// but with [earned] points earned, so a fresh save has some to spend. The
/// skills are re-read on every build, so a raise shows.
Override managerWithPoints(int earned) =>
    managerViewProvider(kSeededCareerId).overrideWith((ref) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(kSeededCareerId);
      if (career == null) return null;
      final skills = <ManagerSkill, int>{
        ManagerSkill.manManagement: career.skillManManagement,
        ManagerSkill.tactical: career.skillTactical,
        ManagerSkill.youthDevelopment: career.skillYouthDevelopment,
        ManagerSkill.negotiation: career.skillNegotiation,
      };
      return (
        career: career,
        skills: skills,
        pointsEarned: earned,
        pointsAvailable: ManagerSkills.pointsAvailable(
          earned: earned,
          levels: skills,
        ),
        staffWages: 0,
      );
    });

/// One Y post, its handle the name without spaces.
YPost fakePost(
  String name,
  YVoice voice,
  String key,
  DateTime date, {
  YTemplate template = YTemplate.winTight,
  List<String> args = const ['Spain', '2-1'],
  String? replyTo,
  YMood? mood,
}) => (
  voice: voice,
  handle: '@${name.replaceAll(' ', '')}',
  displayName: name,
  template: template,
  variant: 0,
  args: args,
  date: date,
  key: key,
  replyTo: replyTo,
  mood: mood,
);

/// A feed with something in it: the 2-1 win and three replies (the most
/// talked about), a draw and one reply, then a tournament exit kept back from
/// earlier in the cycle, below the seam. Ana Fan posts twice, so she leads
/// the voices.
YTimeline fakeYTimeline() {
  final win = DateTime(2027, 6, 10);
  final draw = DateTime(2027, 6, 6);
  return (
    posts: [
      fakePost('Ana Fan', YVoice.fan, 'fx:1|fan', win),
      fakePost(
        'Ben Stats',
        YVoice.stats,
        'fx:1|stats',
        win,
        replyTo: 'fx:1|fan',
      ),
      fakePost(
        'Cid Rival',
        YVoice.rival,
        'fx:1|rival',
        win,
        template: YTemplate.reaction,
        mood: YMood.fury,
        replyTo: 'fx:1|fan',
      ),
      fakePost(
        'Dee Pundit',
        YVoice.pundit,
        'fx:1|pundit',
        win,
        replyTo: 'fx:1|fan',
      ),
      fakePost(
        'Ana Fan',
        YVoice.fan,
        'fx:2|fan',
        draw,
        template: YTemplate.drew,
      ),
      fakePost(
        'Eli Meme',
        YVoice.meme,
        'fx:2|meme',
        draw,
        template: YTemplate.drew,
        replyTo: 'fx:2|fan',
      ),
      fakePost(
        'Fay Wire',
        YVoice.breaking,
        'out:1|breaking',
        DateTime(2026, 7, 1),
        template: YTemplate.eliminated,
        args: const ['European Championship'],
      ),
    ],
    reserveFrom: 6,
  );
}

/// The top bar's Continue, whose label is the hub's next event.
PrimaryButton topBarContinue(WidgetTester tester) =>
    tester.widget<PrimaryButton>(
      find.descendant(
        of: find.byType(TabletTopBar),
        matching: find.byType(PrimaryButton),
      ),
    );
