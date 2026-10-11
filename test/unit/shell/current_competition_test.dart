import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/shell/current_competition.dart';

void main() {
  Fixture fixture(String? round) => Fixture(
    id: 1,
    careerId: 7,
    competitionId: 3,
    matchday: 1,
    date: DateTime(2026, 9, 6),
    homeNationId: 1,
    awayNationId: 2,
    round: round,
  );

  CurrentCompetition? of(
    String? round,
    String? name, {
    Confederation? conf = Confederation.europe,
  }) => currentCompetitionFor(
    careerId: 7,
    next: fixture(round),
    name: name,
    confederation: conf,
  );

  test('World Championship qualifiers open the World Championship', () {
    final c = of(null, 'Europe Qualifiers')!;
    expect(c.location, '${Routes.cup}?careerId=7');
    // Named for the cup they lead to, not the continent they are played in.
    expect(c.name, 'World Cup Qualifiers');
  });

  test('World Championship finals open the World Championship', () {
    final c = of('QF', 'World Championship')!;
    expect(c.location, '${Routes.cup}?careerId=7');
    expect(c.name, 'World Championship');
  });

  test("continental qualifiers open the manager's continental cup", () {
    final c = of('CQ', 'European Championship Qualifiers')!;
    expect(c.location, '${Routes.continental}?careerId=7&conf=europe');
    expect(c.name, 'European Championship Qualifiers');
    expect(
      of('CSF', 'African Championship', conf: Confederation.africa)!.location,
      '${Routes.continental}?careerId=7&conf=africa',
    );
  });

  test("a Nations Cup fixture opens the manager's Nations Cup", () {
    final c = of('NGROUP', 'North America Nations Cup')!;
    expect(c.location, '${Routes.nationsCup}?careerId=7');
    expect(c.name, 'North America Nations Cup');
  });

  test('the Clash and the play-off open their own screens', () {
    expect(
      of('FFINAL', 'Continental Clash')!.location,
      '${Routes.continentalClash}?careerId=7',
    );
    expect(
      of('SF', 'Intercontinental Play-off')!.location,
      '${Routes.intercontinentalPlayoff}?careerId=7',
    );
  });

  test('no link without a competition to go to', () {
    expect(
      currentCompetitionFor(
        careerId: 7,
        next: null,
        name: null,
        confederation: Confederation.europe,
      ),
      isNull,
    );
    expect(of('FRIENDLY', 'Friendlies'), isNull);
    // A continental fixture with no confederation has no screen to open.
    expect(of('CQ', 'European Championship Qualifiers', conf: null), isNull);
  });
}
