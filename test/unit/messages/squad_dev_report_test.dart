import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';

void main() {
  const rows = [
    SquadDevRow(
      name: 'Faded Veteran',
      age: 35,
      position: 'CB',
      rating: 74,
      change: -3,
      status: SquadDevStatus.stayed,
    ),
    SquadDevRow(
      name: 'Retired Keeper',
      age: 37,
      position: 'GK',
      rating: 70,
      status: SquadDevStatus.gone,
    ),
    SquadDevRow(
      name: 'Rising Star',
      age: 19,
      position: 'ST',
      rating: 71,
      status: SquadDevStatus.arrived,
    ),
    SquadDevRow(
      name: 'Steady Eddie',
      age: 27,
      position: 'CM',
      rating: 80,
      change: 2,
      status: SquadDevStatus.stayed,
    ),
  ];

  test('round-trips every player, ordering newcomers → gains → departures', () {
    final decoded = decodeSquadDevReport(encodeSquadDevReport(rows))!.rows;
    expect(decoded.map((r) => r.name), [
      'Rising Star', // arrived first
      'Steady Eddie', // then by what the year gave them
      'Faded Veteran',
      'Retired Keeper', // departures last
    ]);
    final star = decoded.first;
    expect(star.age, 19);
    expect(star.position, 'ST');
    expect(star.rating, 71);
    expect(star.change, isNull);
    expect(star.status, SquadDevStatus.arrived);
    expect(decoded[2].change, -3);
    expect(decoded.last.status, SquadDevStatus.gone);
  });

  test('a plain-text body is not mistaken for a report', () {
    expect(decodeSquadDevReport('A settled year across the squad.'), isNull);
    expect(decodeSquadDevReport(''), isNull);
  });

  test('a name containing the separator cannot break a row', () {
    final decoded = decodeSquadDevReport(
      encodeSquadDevReport(const [
        SquadDevRow(
          name: 'Odd|Name',
          age: 24,
          position: 'LW',
          rating: 77,
          change: 1,
          status: SquadDevStatus.stayed,
        ),
      ]),
    )!.rows;
    expect(decoded.single.name, 'Odd Name');
    expect(decoded.single.rating, 77);
    expect(decoded.single.change, 1);
  });

  group('the note above the table', () {
    const one = [
      SquadDevRow(
        name: 'Jan Novak',
        age: 11,
        position: 'CM',
        rating: 40,
        status: SquadDevStatus.arrived,
        stars: 4,
      ),
    ];

    test('carries a note when one is given', () {
      final decoded = decodeSquadDevReport(
        encodeSquadDevReport(one, note: 'The academy money is showing.'),
      );
      expect(decoded!.note, 'The academy money is showing.');
      expect(decoded.rows.single.name, 'Jan Novak');
      expect(decoded.rows.single.stars, 4);
    });

    test('has no note when none is given', () {
      final decoded = decodeSquadDevReport(encodeSquadDevReport(one));
      expect(decoded!.note, isNull);
      expect(decoded.rows, hasLength(1));
    });

    test('a body written before notes existed still decodes', () {
      // The guard that matters: reports already sitting in players' saves
      // were written with the v1 tag and must keep rendering, rows intact.
      const legacy =
          'SQUADDEV1\n'
          'Old Player|24|ST|78|3||\n'
          'Gone Player|35|GK|70||out|';
      final decoded = decodeSquadDevReport(legacy);
      expect(decoded, isNotNull);
      expect(decoded!.note, isNull);
      expect(decoded.rows, hasLength(2));
      expect(decoded.rows.first.name, 'Old Player');
      expect(decoded.rows.first.change, 3);
      expect(decoded.rows.last.status, SquadDevStatus.gone);
    });

    test('a note with no rows decodes to an empty table, not an error', () {
      final decoded = decodeSquadDevReport(
        encodeSquadDevReport(const [], note: 'A quiet year.'),
      );
      expect(decoded!.note, 'A quiet year.');
      expect(decoded.rows, isEmpty);
    });

    test('a note containing a newline cannot break the format', () {
      final decoded = decodeSquadDevReport(
        encodeSquadDevReport(one, note: 'one\ntwo'),
      );
      expect(decoded!.note, 'one two');
      expect(decoded.rows, hasLength(1));
    });
  });
}
