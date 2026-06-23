import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/shared/widgets/country_flag.dart';

/// A circular national flag "enamel disc": the flag clipped to a circle inside
/// a ringed container, finished with a soft radial lens highlight. This is the
/// flag treatment used on the nation-select screen.
class FlagDisc extends StatelessWidget {
  const FlagDisc(
    this.code, {
    this.size = 64,
    this.highlighted = false,
    super.key,
  });

  /// FIFA 3-letter code.
  final String code;

  /// Outer diameter.
  final double size;

  /// Highlights the ring with the primary accent (e.g. for a selected nation).
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: highlighted
              ? AppColors.primary.withValues(alpha: 0.6)
              : AppColors.outlineVariant,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CountryFlag(code),
            // Lens highlight: a soft sheen from the upper-left.
            const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(-0.4, -0.4),
                  radius: 0.9,
                  colors: [Color(0x33FFFFFF), Color(0x00000000)],
                  stops: [0, 0.6],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
