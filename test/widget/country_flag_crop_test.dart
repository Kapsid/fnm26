import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/country_flag.dart';

/// "The UAE flag should be centred to the left" (owner, 1.1.4): its red band
/// is the hoist quarter, and a disc cropped about the flag's centre lost it.
void main() {
  Alignment anchorOf(WidgetTester tester) =>
      tester.widget<SvgPicture>(find.byType(SvgPicture)).alignment
          as Alignment;

  testWidgets('the UAE flag is cropped from its hoist', (tester) async {
    await tester.pumpWidget(
      const Center(
        child: SizedBox(width: 60, height: 60, child: CountryFlag('UAE')),
      ),
    );
    expect(anchorOf(tester), Alignment.centerLeft);
  });

  testWidgets('other flags are cropped about their centre', (tester) async {
    await tester.pumpWidget(
      const Center(
        child: SizedBox(width: 60, height: 60, child: CountryFlag('FRA')),
      ),
    );
    expect(anchorOf(tester), Alignment.center);
  });
}
