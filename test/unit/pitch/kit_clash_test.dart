import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

Nation n(int id, String p, String s) => Nation(
  id: id,
  name: 'N$id',
  code: 'N$id',
  confederation: Confederation.europe,
  ranking: 10,
  primaryColor: p,
  secondaryColor: s,
);

void main() {
  test('white vs white clashes and resolves', () {
    final r = KitClash.resolve(
      n(1, '#FFFFFF', '#CC0000'),
      n(2, '#FAFAFA', '#003399'),
    );
    expect(KitClash.clashes(r.home.primary, r.away.primary), isFalse);
    expect(r.away.primary, KitColors.parse('#003399'));
  });

  test(
    'white vs white with a white secondary falls back to the neutral kit',
    () {
      final r = KitClash.resolve(
        n(1, '#FFFFFF', '#FFFFFF'),
        n(2, '#F5F5F5', '#FFFFFF'),
      );
      expect(KitClash.clashes(r.home.primary, r.away.primary), isFalse);
    },
  );

  test('similar reds resolve', () {
    final r = KitClash.resolve(
      n(1, '#D32F2F', '#FFFFFF'),
      n(2, '#C62828', '#FFD600'),
    );
    expect(KitClash.clashes(r.home.primary, r.away.primary), isFalse);
    expect(r.away.primary, KitColors.parse('#FFD600'));
  });

  test('two blacks clash and resolve', () {
    final r = KitClash.resolve(
      n(1, '#000000', '#FFFFFF'),
      n(2, '#101010', '#111111'),
    );
    expect(KitClash.clashes(r.home.primary, r.away.primary), isFalse);
  });

  test('different colours keep their own kits', () {
    final r = KitClash.resolve(
      n(1, '#D32F2F', '#FFFFFF'),
      n(2, '#1565C0', '#FFFFFF'),
    );
    expect(r.away.primary, KitColors.parse('#1565C0'));
  });
}
