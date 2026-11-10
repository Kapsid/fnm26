import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:shared_preferences/shared_preferences.dart';

import '../../story/driver.dart';

/// Player report (1.0.9): picking the FIRST applicant for a job hired
/// somebody else. He chose a Spanish coach and the room showed a Brazilian,
/// who was now first in the list; picking the second or third put the
/// Spaniard back. The first one could never be hired.
///
/// The basic applicant is drawn twice (with and without the 1.0.9 home bias)
/// and both draws carried the same id, so once his id was stored the room
/// took him for a pre-1.0.9 hire and switched the whole list back to the old
/// draw. These hold down that the man you pick is the man you get, in every
/// job, and that the list he was picked from does not change under you.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() => AppLog.debugUse(null));

  test(
    'picking each applicant hires exactly him; the list stays put',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        kMatchViewModePrefsKey: 'timeline',
      });
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final c = storyContainer(db, 0);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      final careerId = (await StoryDriver.start(c, 7)).careerId;

      Future<StaffRoom> room() async {
        c.invalidate(staffRoomProvider(careerId));
        final r = await c.read(staffRoomProvider(careerId).future);
        return r!;
      }

      // The test only bites if a basic applicant's home draw differs from the
      // old one; make sure this save has one.
      final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
      final pool = await staffNamePool(c.read, careerId);
      var homeDiffers = false;

      final shown = await room();
      for (final role in StaffRole.values) {
        final old = StaffMarket.forRole(
          saveSeed: career.rngSeed,
          cycle: career.cyclePointer,
          role: role,
          namePool: pool,
        ).first;
        final listed = shown.applicants[role]!;
        if (old.name != listed.first.name ||
            old.country != listed.first.country) {
          homeDiffers = true;
        }

        for (final pick in [...listed, listed.first]) {
          await c.read(managerServiceProvider).hire(careerId, role, pick.id);
          final after = await room();
          final hired = after.hired[role]!;
          expect(
            (hired.name, hired.country, hired.tier),
            (pick.name, pick.country, pick.tier),
            reason: '$role: picked ${pick.name} (${pick.country})',
          );
          expect(after.applicants[role], listed, reason: '$role list moved');
        }
      }
      expect(homeDiffers, isTrue, reason: 'pick a seed with a home draw');

      // A basic coach hired before 1.0.9 (an unmarked id, stored in old saves)
      // keeps the name and flag he was hired under.
      for (final role in StaffRole.values) {
        final oldList = StaffMarket.forRole(
          saveSeed: career.rngSeed,
          cycle: career.cyclePointer,
          role: role,
          namePool: pool,
        );
        await c
            .read(careerRepositoryProvider)
            .setStaff(
              careerId,
              role,
              oldList.first.id,
            );
        final after = await room();
        expect(after.hired[role], oldList.first, reason: '$role');
        expect(after.applicants[role], oldList, reason: '$role');
      }
    },
  );
}
