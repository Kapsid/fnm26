import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/transfer_report.dart';

/// The window's moves, as one report.
///
/// They used to arrive as separate messages capped at three, so a manager
/// watched a handful of his squad change club and got no account of the rest —
/// his own players moved and nobody told him.
void main() {
  const rows = <TransferRow>[
    (
      name: 'Tomas Novak',
      position: 'CB',
      from: 'Prague Green',
      to: 'Man Blue',
      fee: '€24M',
      abroad: true,
      rating: 84,
      change: 3,
      step: 1,
    ),
    (
      name: 'Petr Svoboda',
      position: 'CM',
      from: 'Prague Green',
      to: 'Brno Stripes',
      fee: '€2.4M',
      abroad: false,
      rating: 71,
      change: -2,
      step: -1,
    ),
  ];

  test('a report survives the round trip through the inbox', () {
    final decoded = decodeTransferReport(encodeTransferReport(rows));
    expect(decoded, isNotNull);
    expect(decoded, hasLength(2));
    expect(decoded!.first.name, 'Tomas Novak');
    expect(decoded.first.fee, '€24M');
    expect(decoded.first.abroad, isTrue);
    expect(decoded.last.abroad, isFalse);
  });

  test('a report carries what the move meant, not just where it went', () {
    // Two club names and a fee told a manager nothing about whether his player
    // had gone up or down, or what the year had done to him.
    final decoded = decodeTransferReport(encodeTransferReport(rows))!;
    expect(decoded.first.rating, 84);
    expect(decoded.first.change, 3);
    expect(decoded.first.step, 1, reason: 'a step up');
    expect(decoded.last.change, -2);
    expect(decoded.last.step, -1, reason: 'a step down');
  });

  test('a report written by an older build still renders', () {
    // v1 bodies are sitting in players' saves and must keep decoding. They
    // carry no rating, which is what tells the table to leave that column out
    // rather than print a nought beside every name.
    const v1 =
        '#transfers/v1\n'
        'Tomas Novak|CB|Prague Green|Man Blue|€24M|abroad';
    final decoded = decodeTransferReport(v1);
    expect(decoded, hasLength(1));
    expect(decoded!.single.name, 'Tomas Novak');
    expect(decoded.single.abroad, isTrue);
    expect(decoded.single.rating, 0, reason: 'nothing was recorded');
    expect(decoded.single.change, isNull);
    expect(decoded.single.step, 0);
  });

  test('every move is carried, not the top three', () {
    final many = [
      for (var i = 0; i < 14; i++)
        (
          name: 'Player $i',
          position: 'CM',
          from: 'A',
          to: 'B',
          fee: '€1M',
          abroad: false,
          rating: 70,
          change: 0,
          step: 0,
        ),
    ];
    expect(decodeTransferReport(encodeTransferReport(many)), hasLength(14));
  });

  test('a pipe in a club name cannot break the table', () {
    final odd = [
      (
        name: 'Odd | Name',
        position: 'ST',
        from: 'A | B',
        to: 'C',
        fee: '€1M',
        abroad: false,
        rating: 70,
        change: null,
        step: 0,
      ),
    ];
    final decoded = decodeTransferReport(encodeTransferReport(odd));
    expect(decoded, hasLength(1));
    expect(decoded!.single.to, 'C');
    expect(decoded.single.fee, '€1M');
  });

  test('any other message body is left alone', () {
    expect(decodeTransferReport('The board are pleased.'), isNull);
    expect(decodeTransferReport(''), isNull);
  });

  test('an empty window encodes to a report with no rows', () {
    expect(decodeTransferReport(encodeTransferReport(const [])), isEmpty);
  });
}
