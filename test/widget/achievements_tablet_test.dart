import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/domain/services/achievements/challenges.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/achievements/achievements_screen.dart';
import 'package:fnm/features/achievements/challenge_providers.dart';
import 'package:fnm/features/achievements/challenges_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, String path, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, '$path?careerId=${save.careerId}', size: size);
  return save;
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

/// The panel headed [title] (panel headers are upper case).
Finder _panel(String title) => find
    .ancestor(
      of: find.text(title.toUpperCase()).first,
      matching: find.byType(Panel),
    )
    .first;

String _firstTitle(AchievementCategory c) => achievementText(
  enL,
  AchievementCatalog.all.firstWhere((a) => a.category == c),
).title;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('achievements: the categories beside the first one, $size', (
      tester,
    ) async {
      await _open(tester, Routes.achievements, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(AchievementsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // The layout opens on the first category, in the enum's order, that
      // has any achievement.
      final first = AchievementCategory.values.firstWhere(
        (c) => AchievementCatalog.all.any((a) => a.category == c),
      );
      final list = tester.getRect(
        find.byKey(ValueKey('achievements.category.${first.name}')),
      );
      final open = tester.getRect(
        _panel(achievementCategoryLabel(enL, first)),
      );
      expect(open.left, greaterThan(list.right));
      expect(find.text(_firstTitle(first)), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('challenges: the tiers beside the first one, $size', (
      tester,
    ) async {
      await _open(tester, Routes.challenges, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ChallengesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text(enL.achievementsHardestTests), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a category opens beside the list', (tester) async {
    await _open(tester, Routes.achievements, kTabletSize);
    const picked = AchievementCategory.titles;
    expect(find.text(_firstTitle(picked)), findsNothing);
    await tester.tap(
      find.byKey(ValueKey('achievements.category.${picked.name}')),
    );
    await settle(tester);
    expect(_panel(achievementCategoryLabel(enL, picked)), findsOneWidget);
    expect(find.text(_firstTitle(picked)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the heading goes to the challenges', (tester) async {
    final save = await _open(tester, Routes.achievements, kTabletSize);
    await tester.tap(find.text(enL.careerChallenges));
    await settle(tester);
    expect(_path(save), Routes.challenges);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tier opens beside the list; back is the achievements', (
    tester,
  ) async {
    final save = await _open(tester, Routes.challenges, kTabletSize);
    late List<ChallengeView> views;
    await tester.runAsync(() async {
      final sub = save.container.listen(
        challengesViewProvider(save.careerId).future,
        (_, _) {},
      );
      views = await sub.read();
      sub.close();
    });
    final silver = views.firstWhere(
      (v) => !v.def.procedural && v.def.tier == ChallengeTier.silver,
    );
    final title = challengeText(enL, silver.def, silver.target).title;
    expect(find.text(title), findsNothing);
    await tester.tap(find.byKey(const ValueKey('challenges.section.silver')));
    await settle(tester);
    expect(find.text(title), findsOneWidget);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_path(save), Routes.achievements);
    await tester.pumpWidget(const SizedBox());
  });
}
