import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/shell_destinations.dart';

void main() {
  Uri u(String s) => Uri.parse(s);

  test('every destination keeps the career in its link', () {
    for (final d in shellDestinations) {
      expect(
        Uri.parse(d.location(7)).queryParameters['careerId'],
        '7',
        reason: d.id.name,
      );
    }
  });

  test('squad and tactics share a screen but not a highlight', () {
    expect(activeDestination(u('/tactics?careerId=1&tab=3')), ShellDestinationId.squad);
    expect(activeDestination(u('/tactics?careerId=1')), ShellDestinationId.tactics);
    expect(activeDestination(u('/tactics?careerId=1&tab=1')), ShellDestinationId.tactics);
  });

  test('screens under a destination light it up', () {
    expect(activeDestination(u('${Routes.cup}?careerId=1')), ShellDestinationId.tournaments);
    // The Nations Cup has no item of its own; it sits under Tournaments.
    expect(activeDestination(u('${Routes.nationsCup}?careerId=1')), ShellDestinationId.tournaments);
    expect(activeDestination(u('${Routes.careerSummary}?careerId=1')), ShellDestinationId.career);
  });

  test('a screen with no home in the sidebar lights nothing', () {
    expect(activeDestination(u('${Routes.player}?careerId=1&playerId=4')), isNull);
  });

  test('event-only screens are not in the sidebar', () {
    final paths = shellDestinations.map((d) => d.path).toSet();
    expect(paths, isNot(contains(Routes.trainingCamp)));
    expect(paths, isNot(contains(Routes.naturalization)));
  });
}
