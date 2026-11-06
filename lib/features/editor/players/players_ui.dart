import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/club_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:go_router/go_router.dart';

/// Back one screen: the page under this one when it was pushed, else
/// [parent] (a page opened straight from a link or a jump).
void editorBack(BuildContext context, String parent) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(parent);
  }
}

const Map<String, String> _plain = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a', 'ā': 'a', //
  'ą': 'a', 'æ': 'ae', 'ç': 'c', 'č': 'c', 'ć': 'c', 'ď': 'd', 'đ': 'd',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', 'ě': 'e', 'ē': 'e', 'ę': 'e',
  'ğ': 'g', 'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', 'ı': 'i', 'ī': 'i',
  'ľ': 'l', 'ĺ': 'l', 'ł': 'l', 'ñ': 'n', 'ň': 'n', 'ń': 'n', 'ó': 'o',
  'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o', 'ő': 'o', 'ō': 'o',
  'œ': 'oe', 'ř': 'r', 'ŕ': 'r', 'š': 's', 'ś': 's', 'ş': 's', 'ș': 's',
  'ß': 'ss', 'ť': 't', 'ţ': 't', 'ț': 't', 'ú': 'u', 'ù': 'u', 'û': 'u',
  'ü': 'u', 'ů': 'u', 'ű': 'u', 'ū': 'u', 'ý': 'y', 'ÿ': 'y', 'ž': 'z',
  'ź': 'z', 'ż': 'z',
};

/// [s] as a search compares it: lower case, Latin accents dropped, so
/// "cesko" finds Česko.
String searchFold(String s) {
  final lower = s.toLowerCase().trim();
  final out = StringBuffer();
  for (final r in lower.runes) {
    final ch = String.fromCharCode(r);
    out.write(_plain[ch] ?? ch);
  }
  return out.toString();
}

/// A position group's short label (GK, DEF, MID, FWD).
String categoryShort(AppLocalizations l, PositionCategory c) => switch (c) {
  PositionCategory.goalkeeper => l.editorShortGk,
  PositionCategory.defender => l.editorShortDef,
  PositionCategory.midfielder => l.editorShortMid,
  PositionCategory.forward => l.editorShortFwd,
};

/// A position group's heading in the squad list.
String categoryTitle(AppLocalizations l, PositionCategory c) => switch (c) {
  PositionCategory.goalkeeper => l.tacticsGoalkeepers,
  PositionCategory.defender => l.tacticsDefenders,
  PositionCategory.midfielder => l.tacticsMidfielders,
  PositionCategory.forward => l.tacticsForwards,
};

String playerTypeLabel(AppLocalizations l, PlayerType t) => switch (t) {
  PlayerType.balanced => l.editorTypeBalanced,
  PlayerType.athlete => l.editorTypeAthlete,
  PlayerType.technician => l.editorTypeTechnician,
  PlayerType.engine => l.editorTypeEngine,
};

String playerTypeAbout(AppLocalizations l, PlayerType t) => switch (t) {
  PlayerType.balanced => l.editorTypeBalancedAbout,
  PlayerType.athlete => l.editorTypeAthleteAbout,
  PlayerType.technician => l.editorTypeTechnicianAbout,
  PlayerType.engine => l.editorTypeEngineAbout,
};

/// [p]'s name, or "Unnamed player" while he has none.
String playerLabel(AppLocalizations l, PackPlayer p) =>
    p.name.trim().isEmpty ? l.editorPlayerUnnamed : p.name.trim();

/// [p]'s club as the game will show it: under the pack's new name for it
/// (an added club keeps its own, as in a career: [ClubService.renamed]),
/// "Free agent" or "Chosen by the game".
String clubLabel(AppLocalizations l, WorldPack pack, PackPlayer p) =>
    switch (p.club) {
      null => l.editorPlayerClubAuto,
      final club
          when pack.addedClubs.any(
            (c) => c.name == club && c.country == p.clubCountry?.toLowerCase(),
          ) =>
        clubName(l, club),
      final club => clubName(l, pack.clubs[club] ?? club),
    };

/// The colour an overall reads in: green for the elite, red for the weak.
Color overallColor(int overall) => overall >= 80
    ? AppColors.ratingGreat
    : overall >= 70
    ? AppColors.ratingGood
    : overall >= 50
    ? AppColors.onSurface
    : AppColors.ratingPoor;

/// A small rounded badge with a position's short code.
class PositionBadge extends StatelessWidget {
  const PositionBadge(this.position, {super.key});

  final PlayerPosition position;

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    padding: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.12),
      borderRadius: AppRadii.smAll,
    ),
    alignment: Alignment.center,
    child: Text(
      position.label,
      style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
    ),
  );
}

/// An editor page in the phone or the tablet frame: a [TabletPage] keyed
/// [tabletKey] on a landscape tablet, else a [Scaffold] with an app bar.
/// [actions] go in the app bar (or the tablet header); [fab] is the phone's
/// floating button (on a tablet the caller puts that action in [actions]).
class EditorFrame extends StatelessWidget {
  const EditorFrame({
    required this.tablet,
    required this.tabletKey,
    required this.title,
    required this.onBack,
    required this.body,
    this.actions = const [],
    this.fab,
    super.key,
  });

  final bool tablet;
  final Key tabletKey;
  final String title;
  final VoidCallback onBack;
  final Widget body;
  final List<Widget> actions;
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    if (tablet) {
      return TabletPage(
        scaffoldKey: tabletKey,
        title: title,
        onBack: onBack,
        trailing: actions.isEmpty
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.sm,
                children: actions,
              ),
        child: body,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: onBack,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: actions,
      ),
      floatingActionButton: fab,
      body: SafeArea(top: false, child: body),
    );
  }
}

/// A centred line for a page with nothing to show (yet).
class EditorMessage extends StatelessWidget {
  const EditorMessage(this.text, {this.icon, super.key});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 40, color: AppColors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
