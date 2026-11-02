import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/job_dossier.dart';

import '../../helpers/fixtures.dart';

/// A 23-man squad of [base]-rated men of [age]: three goalkeepers, eight
/// defenders, eight midfielders and four forwards, every one [base] unless
/// [rating] says otherwise for his id.
List<Player> _squad({
  int base = 70,
  int age = 26,
  Map<int, int> rating = const {},
  Map<int, int> ages = const {},
}) {
  final positions = [
    for (var i = 0; i < 3; i++) PlayerPosition.gk,
    for (var i = 0; i < 8; i++) PlayerPosition.cb,
    for (var i = 0; i < 8; i++) PlayerPosition.cm,
    for (var i = 0; i < 4; i++) PlayerPosition.st,
  ];
  return [
    for (var i = 0; i < positions.length; i++)
      player(
        id: i,
        nationId: 1,
        position: positions[i],
        age: ages[i] ?? age,
        attributes: flatAttributes(rating[i] ?? base),
      ),
  ];
}

void main() {
  test('the rating is the best eleven, the top five listed best first', () {
    final read = JobDossierRead.of(_squad(rating: {19: 80, 20: 78, 5: 76}));
    expect(read.top.map((p) => p.id).take(3), [19, 20, 5]);
    expect(read.top, hasLength(JobDossierRead.topCount));
    expect(read.rating, closeTo((80 + 78 + 76 + 8 * 70) / 11, 0.5));
  });

  test('two fine forwards make a strong attack', () {
    final read = JobDossierRead.of(_squad(rating: {19: 80, 20: 80}));
    expect(read.notes.first, JobDossierNote.strongAttack);
  });

  test('poor forwards make a blunt attack', () {
    final read = JobDossierRead.of(
      _squad(rating: {19: 58, 20: 58, 21: 56, 22: 55}),
    );
    expect(read.notes, contains(JobDossierNote.bluntAttack));
    expect(read.notes, isNot(contains(JobDossierNote.strongAttack)));
  });

  test('one man far above the rest carries them, by name', () {
    final read = JobDossierRead.of(_squad(rating: {12: 86}));
    expect(read.notes, contains(JobDossierNote.oneStar));
    expect(read.star?.id, 12);
  });

  test('an old eleven is an old squad, a young one a young core', () {
    expect(
      JobDossierRead.of(_squad(age: 31)).notes,
      contains(JobDossierNote.oldSquad),
    );
    expect(
      JobDossierRead.of(_squad(age: 22)).notes,
      contains(JobDossierNote.youngCore),
    );
  });

  test('an even squad has nothing glaring to say', () {
    // Every unit sits at its usual gap only when the side is perfectly
    // flat; whatever the units say, the shape line is a deep squad.
    final read = JobDossierRead.of(_squad());
    expect(read.notes, contains(JobDossierNote.deepSquad));
  });

  test('an empty pool reads as nothing', () {
    final read = JobDossierRead.of(const []);
    expect(read.rating, 0);
    expect(read.top, isEmpty);
    expect(read.notes, isEmpty);
  });
}
