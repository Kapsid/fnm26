import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import '../../helpers/pitch_view_fixture.dart' show pitchNation;

PitchStadium _ground(Nation home, Nation away) => PitchStadium.forMatch(
  ground: (
    stadium: 'Mock Arena',
    city: 'Brno',
    groundNationId: home.id,
    capacity: 30000,
    attendance: 27000,
    soldOut: false,
  ),
  home: home,
  away: away,
  awayShare: 0.1,
  date: DateTime(2026, 9, 10),
  kickOff: const KickOffTime(20, 45),
);

void main() {
  test('the same match is the same ground; edited kit colours are not', () {
    final cze = pitchNation('CZE');
    final por = pitchNation('POR');
    expect(_ground(cze, por), _ground(cze, por));
    // A nation's colours edited (same code): another crowd and other shirts,
    // so the view must bake again, never reuse the old images.
    final recoloured = Nation(
      id: cze.id,
      name: cze.name,
      code: cze.code,
      confederation: cze.confederation,
      ranking: cze.ranking,
      primaryColor: '#00AA00',
      secondaryColor: cze.secondaryColor,
    );
    expect(_ground(recoloured, por), isNot(_ground(cze, por)));
    final awayRecoloured = Nation(
      id: por.id,
      name: por.name,
      code: por.code,
      confederation: por.confederation,
      ranking: por.ranking,
      primaryColor: por.primaryColor,
      secondaryColor: '#123456',
    );
    expect(_ground(cze, awayRecoloured), isNot(_ground(cze, por)));
  });
}
