import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// Renders a nation's flag (bundled SVG, offline) for a FIFA [code], cropped to
/// fill its box. Falls back to the code text if the asset is missing.
///
/// Pair with `FlagDisc`/`NationBadge` for the circular "enamel" lens treatment.
class CountryFlag extends StatelessWidget {
  const CountryFlag(this.code, {super.key});

  /// FIFA 3-letter code (e.g. `BRA`); assets are named `assets/flags/bra.svg`.
  final String code;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/flags/${code.toLowerCase()}.svg',
      fit: BoxFit.cover,
      placeholderBuilder: (_) => _fallback(),
    );
  }

  Widget _fallback() => ColoredBox(
    color: const Color(0xFF1E2022),
    child: Center(
      child: Text(
        code.toUpperCase(),
        style: AppTypography.labelSmall,
      ),
    ),
  );
}
