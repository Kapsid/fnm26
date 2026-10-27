import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/features/match/match_ground.dart';
import 'package:fnm/features/match/match_providers.dart';

import '../helpers/seeded_save.dart';

/// The match screen and a skipped match must play at the same ground, so
/// at the same altitude and in the same heat: both go through
/// [resolveMatchGround]. This reads the real preview of a seeded save and
/// the resolver for the same fixture, home and away, and asks they agree.
void main() {
  testWidgets('the preview and the background resolve the same ground', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await tester.runAsync(() async {
      final c = save.container;
      final sub = c.listen(
        matchPreviewProvider(save.careerId).future,
        (_, _) {},
      );
      final preview = (await sub.read())!;
      sub.close();
      final career = (await c
          .read(careerRepositoryProvider)
          .byId(save.careerId))!;
      final nations = await c
          .read(nationRepositoryProvider)
          .forCareer(save.careerId);

      Future<MatchGround> resolve(Fixture fixture) {
        final p = FutureProvider<MatchGround>(
          (ref) => resolveMatchGround(
            ref,
            career: career,
            fixture: fixture,
            nations: nations,
          ),
        );
        return c.read(p.future);
      }

      final same = await resolve(preview.fixture);
      expect(same.city, preview.ground.city);
      expect(same.groundNationId, preview.ground.groundNationId);
      expect(
        conditionsAt(preview.fixture, same).awayDrain,
        preview.conditions.awayDrain,
      );

      // The manager's side moved to the other end: the opponent's ground.
      final swapped = preview.fixture.copyWith(
        homeNationId: preview.fixture.awayNationId,
        awayNationId: preview.fixture.homeNationId,
      );
      final away = await resolve(swapped);
      expect(away.groundNationId, swapped.homeNationId);
    });
  });
}
