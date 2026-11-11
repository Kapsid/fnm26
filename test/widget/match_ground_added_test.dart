import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/federation/host_bid_providers.dart'
    show nationStadiumsFor;
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/match/match_ground.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/seeded_save.dart';

/// A stadium a custom world adds joins its nation's grounds in a career on
/// that world: an AI nation's home games rotate over it, the manager's
/// estate holds it, and the shown match and the background agree on it. A
/// career without one plays where it always did.
void main() {
  testWidgets('an added stadium is played at, in the background and on '
      'screen alike', (tester) async {
    final save = await seedSave(tester);
    await tester.runAsync(() async {
      final c = save.container;
      final career = save.career;
      final nations = await c
          .read(nationRepositoryProvider)
          .forCareer(save.careerId);
      final ai = nations.firstWhere((n) => n.id != career.nationId);

      Fixture fixture(int id) => Fixture(
        id: id,
        careerId: career.id,
        competitionId: 1,
        matchday: 1,
        date: DateTime(2027, 10, 10),
        homeNationId: ai.id,
        awayNationId: career.nationId,
        round: id.isEven ? 'FRIENDLY' : null,
      );

      Future<MatchGround> resolve(int id, {MatchGroundMemo? memo}) {
        final p = FutureProvider<MatchGround>(
          (ref) => resolveMatchGround(
            ref,
            career: career,
            fixture: fixture(id),
            nations: nations,
            memo: memo,
          ),
        );
        return c.read(p.future);
      }

      Future<List<String>> grounds({MatchGroundMemo? memo}) async => [
        for (var id = 1; id <= 40; id++)
          (await resolve(id, memo: memo)).stadium,
      ];

      final before = await grounds();
      expect(before, isNot(contains('Testford Arena')));

      // The career now runs on a world that adds a ground to each side.
      final repo = c.read(worldPackRepositoryProvider);
      final packId = await repo.insert(
        WorldPack(
          uuid: 'added-grounds',
          name: 'Grounds',
          author: '',
          formatVersion: kPackFormatVersion,
          madeWithVersion: '1.1.1',
          addedStadiums: [
            PackStadium(
              id: kPackAddedIdBase,
              nationId: ai.id,
              name: 'Testford Arena',
              city: 'Testford',
              capacity: 150000,
            ),
            PackStadium(
              id: kPackAddedIdBase + 1,
              nationId: career.nationId,
              name: 'Home Park Nova',
              city: 'Newtown',
              capacity: 5000,
            ),
          ],
        ),
        const {},
      );
      await repo.copyToCareer(packId, career.id);

      final after = await grounds();
      expect(after, contains('Testford Arena'));
      // Determined by the fixture alone: a batch with a memo agrees.
      expect(await grounds(memo: MatchGroundMemo()), after);
      final testford = await resolve(after.indexOf('Testford Arena') + 1);
      expect(testford.city, 'Testford');
      expect(testford.capacity, 150000);
      expect(testford.groundNationId, ai.id);

      // The manager's estate holds his.
      final estate = await c.read(
        FutureProvider(
          (ref) => careerStadiumsFor(ref, career.id, career.nationId),
        ).future,
      );
      expect(estate.map((s) => s.name), contains('Home Park Nova'));
      // A finals, or a bid for one, never counts it.
      final bid = await c.read(
        FutureProvider(
          (ref) => nationStadiumsFor(ref, career.id, career.nationId),
        ).future,
      );
      expect(bid.map((v) => v.stadium), isNot(contains('Home Park Nova')));
      expect(bid, hasLength(estate.length - 1));
    });
  });
}
