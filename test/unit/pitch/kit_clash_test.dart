import 'package:flutter/painting.dart';
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

  // Regression: a scarlet/blue home side against a crimson/navy away side.
  // The two reds sit just past the colour-difference threshold, so the pitch
  // used to dress both teams in red while the TV bar (its own hue rule) showed
  // the away side blue.
  test('a scarlet and a crimson clash, and the bar shows the pitch kits', () {
    final home = n(1, '#D90012', '#0033A0');
    final away = n(2, '#BA0C2F', '#00205B');
    final r = KitClash.resolve(home, away);
    expect(KitClash.clashes(r.home.primary, r.away.primary), isFalse);
    expect(r.away.primary, isNot(KitColors.parse('#BA0C2F')));

    final (homeBar, awayBar) = KitClash.barColours(home, away);
    String hex(Color c) =>
        '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    // The bar is the resolved shirt, lifted: never the kit the side is not
    // wearing.
    expect(awayBar, KitColors.accent(hex(r.away.primary), hex(r.away.primary)));
    expect(homeBar, KitColors.accent(hex(r.home.primary), hex(r.home.primary)));
    expect(KitColors.tooClose(homeBar, awayBar), isFalse);
  });

  test('the bar and the pitch agree for every clashing red pair', () {
    // Shirts the bar shows must be the shirts the pitch dresses, so if the
    // pitch keeps the away side's own kit the bar must too.
    for (final (hp, ap) in [
      ('#E41B17', '#9E1B32'),
      ('#E4002B', '#7B1113'),
      ('#0033A0', '#002F6C'),
    ]) {
      final home = n(1, hp, '#FFFFFF');
      final away = n(2, ap, '#FFD600');
      final r = KitClash.resolve(home, away);
      final (_, awayBar) = KitClash.barColours(home, away);
      expect(
        KitColors.tooClose(
          KitColors.legible(r.away.primary),
          KitColors.legible(KitColors.parse(ap)),
        ),
        isFalse,
        reason: '$hp vs $ap: the away side keeps a clashing shirt',
      );
      expect(
        awayBar,
        isNot(KitColors.accent(ap, ap)),
        reason: '$hp vs $ap: the bar shows a shirt the pitch did not dress',
      );
    }
  });

  test('different colours keep their own kits', () {
    final r = KitClash.resolve(
      n(1, '#D32F2F', '#FFFFFF'),
      n(2, '#1565C0', '#FFFFFF'),
    );
    expect(r.away.primary, KitColors.parse('#1565C0'));
  });
}
