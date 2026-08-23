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
    ),
    (
      name: 'Petr Svoboda',
      position: 'CM',
      from: 'Prague Green',
      to: 'Brno Stripes',
      fee: '€2.4M',
      abroad: false,
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
