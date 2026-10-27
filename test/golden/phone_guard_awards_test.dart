import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/awards/awards_ceremony_screen.dart';
import 'package:fnm/features/messages/poty_card.dart';

import '../helpers/seeded_save.dart';

PotyPlace _place(
  int rank,
  int id,
  String name,
  int nationId,
  String code,
  String nation,
  PlayerPosition position, {
  bool own = false,
  int age = 27,
  int goals = 9,
  int cleanSheets = 5,
  double rating = 7.6,
}) => (
  rank: rank,
  playerId: id,
  nationId: nationId,
  own: own,
  name: name,
  nationCode: code,
  nationName: nation,
  age: age,
  overall: 86,
  position: position,
  apps: 13,
  goals: goals,
  assists: 4,
  cleanSheets: cleanSheets,
  meanRating: rating,
  motms: 3,
  score: 90.0 - rank * 6,
);

/// The year's top-five list on a phone (the ceremony's last screen and the
/// inbox's "See the top five").
void main() {
  testWidgets('phone awards list', (tester) async {
    final vote = (
      best: [
        _place(
          1,
          1,
          'Mateo Fernández',
          56,
          'arg',
          'Argentina',
          PlayerPosition.st,
          goals: 14,
          rating: 7.94,
        ),
        _place(
          2,
          2,
          'Lucas Moreau',
          18,
          'fra',
          'France',
          PlayerPosition.am,
          goals: 8,
        ),
        _place(
          3,
          3,
          'Harry Whitfield',
          14,
          'eng',
          'England',
          PlayerPosition.gk,
          own: true,
          cleanSheets: 8,
          rating: 7.31,
        ),
        _place(
          4,
          4,
          'Nomenjanahary Raheriniaina',
          58,
          'bra',
          'Brazil',
          PlayerPosition.lw,
          goals: 10,
        ),
        _place(
          5,
          5,
          'Jonas Becker',
          20,
          'ger',
          'Germany',
          PlayerPosition.cb,
          cleanSheets: 7,
          goals: 2,
          rating: 7.22,
        ),
      ],
      young: [
        _place(
          1,
          6,
          'Pedri Alonso',
          50,
          'esp',
          'Spain',
          PlayerPosition.cm,
          age: 19,
          goals: 5,
          rating: 7.4,
        ),
        _place(
          2,
          7,
          'Kai Jansen',
          36,
          'ned',
          'Netherlands',
          PlayerPosition.rb,
          age: 20,
          cleanSheets: 6,
          rating: 7.1,
        ),
        _place(
          3,
          8,
          'Tomás Silva',
          41,
          'por',
          'Portugal',
          PlayerPosition.st,
          age: 18,
          goals: 6,
          rating: 7.05,
        ),
      ],
    );
    final save = await seedSave(
      tester,
      overrides: [potyVoteProvider.overrideWith((ref, arg) async => vote)],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.awardsCeremony}?careerId=${save.careerId}&year=2030',
    );
    expect(find.byType(PotyTopList), findsOneWidget);
    await expectAppGolden('goldens/awards_list_phone.png');
  });
}
