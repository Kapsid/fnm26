import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart'
    show continentalKickoffKind, worldCupKickoffKind;
import 'package:fnm/shared/widgets/widgets.dart';

/// A tournament's host-nation re-skin. While a finals is live AND its opening
/// ceremony has been watched, its screens take on the host's colours; before
/// the ceremony (and once the champion is decided) it is [active] `false` and
/// everything looks normal.
///
/// [accent] is the single lead colour (AppBar title, tab indicator). [colors]
/// are every host's kit colours, lifted to legible tones and de-duplicated —
/// the palette the banner pours into a gradient, so a Spain·Portugal edition
/// runs red→yellow→green rather than a single flat tint. [competitionLabel] is
/// the line under the hosts ("WORLD CUP 2030", "EUROPEAN CHAMPIONSHIP 2028"),
/// which is what lets the continental cups use the same banner.
typedef WcHostTheme = ({
  bool active,
  Color accent,
  Color onAccent,
  List<Color> colors,
  List<int> hostIds,
  String hostLabel,
  String competitionLabel,
  int year,
});

WcHostTheme _inactive() => (
      active: false,
      accent: AppColors.primary,
      onAccent: AppColors.onSurface,
      colors: const <Color>[],
      hostIds: const <int>[],
      hostLabel: '',
      competitionLabel: '',
      year: 0,
    );

/// Parses a `#RRGGBB` nation colour into an opaque [Color].
Color hostColorHex(String hex) => KitColors.parse(hex);

/// The host palette to paint the re-skin with: every host's two kit colours,
/// made UI-legible and de-duplicated. Co-hosts contribute all their colours, so
/// the more nations share the finals, the richer the gradient.
List<Color> hostGradientColors(Iterable<Nation> hosts) => KitColors.gradient(
      hosts.map((h) => (h.primaryColor, h.secondaryColor)),
    );

/// A legible accent from a host's two kit colours.
Color usableHostAccent(Nation host) =>
    KitColors.accent(host.primaryColor, host.secondaryColor);

/// Readable text/icon colour to sit on top of [accent].
Color onHostAccent(Color accent) => KitColors.onAccent(accent);

/// The active host theme for [careerId], or an inactive one until the World Cup
/// ceremony has been watched and while a champion is undecided.
final wcHostThemeProvider =
    FutureProvider.autoDispose.family<WcHostTheme, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return _inactive();
  final comp = ref.watch(competitionRepositoryProvider);
  if (!await comp.hasFinals(careerId)) return _inactive();
  // Once the champion is crowned the tournament is over — drop the re-skin.
  if (await comp.worldChampion(careerId) != null) return _inactive();
  // The gate: nothing changes until the opening ceremony has been watched.
  if (!await comp.hasWatchedDraw(
    careerId,
    career.cyclePointer,
    worldCupKickoffKind,
  )) {
    return _inactive();
  }

  final nations = await ref.watch(nationRepositoryProvider).all();
  final year = CareerService.worldCupYear(career.cyclePointer);
  final hostIds = WorldCupHosts.hostsFor(
    year: year,
    nations: nations,
    seed: career.rngSeed,
  );
  if (hostIds.isEmpty) return _inactive();
  final byId = {for (final n in nations) n.id: n};
  final primary = byId[hostIds.first];
  if (primary == null) return _inactive();
  final hostNations =
      hostIds.map((id) => byId[id]).whereType<Nation>().toList();

  final accent = usableHostAccent(primary);
  return (
    active: true,
    accent: accent,
    onAccent: onHostAccent(accent),
    colors: hostGradientColors(hostNations),
    hostIds: hostIds,
    hostLabel: hostIds
        .map((h) => byId[h]?.name.toUpperCase() ?? '')
        .where((s) => s.isNotEmpty)
        .join(' · '),
    competitionLabel: 'WORLD CUP $year',
    year: year,
  );
});

/// The same host re-skin for the player's CONTINENTAL championship — the Euro,
/// the Copa, AFCON and the rest get their host nation's colours exactly as the
/// World Cup does, rather than being the one tournament that stays grey.
///
/// Gated the same way: active only once that cup's opening ceremony has been
/// watched and while it is still being played.
final continentalHostThemeProvider =
    FutureProvider.autoDispose.family<WcHostTheme, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return _inactive();
  final comp = ref.watch(competitionRepositoryProvider);
  final nations = await ref.watch(nationRepositoryProvider).all();
  final byId = {for (final n in nations) n.id: n};
  final me = byId[career.nationId];
  if (me == null) return _inactive();
  final cup = ContinentalCups.byConfederation[me.confederation];
  if (cup == null) return _inactive();

  final cycle = career.cyclePointer;
  // Live means: the cup exists, its ceremony has been watched, and it hasn't
  // finished yet.
  if (!await comp.hasTournament(
    careerId,
    CompetitionKind.continentalFinals,
    confederation: me.confederation,
  )) {
    return _inactive();
  }
  if (!await comp.hasWatchedDraw(careerId, cycle, continentalKickoffKind)) {
    return _inactive();
  }
  if (await comp.allPlayedForKind(
    careerId,
    CompetitionKind.continentalFinals,
    confederation: me.confederation,
  )) {
    return _inactive();
  }

  final hostIds = WorldCupHosts.continentalHostsFor(
    confederation: me.confederation,
    cycle: cycle,
    seed: career.rngSeed,
    nations: nations,
  );
  if (hostIds.isEmpty) return _inactive();
  final primary = byId[hostIds.first];
  if (primary == null) return _inactive();
  final hostNations =
      hostIds.map((id) => byId[id]).whereType<Nation>().toList();

  final year = CareerService.worldCupYear(cycle) - 2; // finals sit two before
  final accent = usableHostAccent(primary);
  return (
    active: true,
    accent: accent,
    onAccent: onHostAccent(accent),
    colors: hostGradientColors(hostNations),
    hostIds: hostIds,
    hostLabel: hostIds
        .map((h) => byId[h]?.name.toUpperCase() ?? '')
        .where((s) => s.isNotEmpty)
        .join(' · '),
    competitionLabel: '${cup.name.toUpperCase()} $year',
    year: year,
  );
});

/// A bold host banner shown atop the World Cup screens once the theme is
/// active: a full gradient poured from every host's kit colours, the host
/// flag(s), and "SPAIN · PORTUGAL / WORLD CUP 2030" in white over a slim scrim
/// that keeps the text legible whatever the kit. Nothing when theme is inactive.
class WcHostBanner extends StatelessWidget {
  const WcHostBanner({required this.theme, required this.code, super.key});

  final WcHostTheme theme;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    if (!theme.active) return const SizedBox.shrink();
    // Two or more colours make a real gradient; a single-colour kit is fanned
    // into a light→deep sweep of itself so it still reads as a gradient band.
    final palette = theme.colors.length >= 2
        ? theme.colors
        : [
            KitColors.shade(theme.accent, 0.10),
            KitColors.shade(theme.accent, -0.18),
          ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadii.mdAll,
        gradient: LinearGradient(colors: palette),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: palette.first.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // A dark scrim (heavier on the left, where the text sits) so white flags
      // and lettering read as clearly over a pale kit (white, yellow) as over a
      // dark one, without dulling the colour on the right.
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadii.mdAll,
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.42),
              Colors.black.withValues(alpha: 0.12),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              for (final h in theme.hostIds) ...[
                FlagDisc(code(h), size: 26),
                const SizedBox(width: 6),
              ],
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      theme.hostLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      theme.competitionLabel,
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.stadium_rounded,
                size: 22,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
