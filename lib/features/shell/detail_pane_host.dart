import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:fnm/shared/tablet/master_detail.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:go_router/go_router.dart';

/// The right-hand pane of a tablet screen: whatever is selected, drawn with
/// the same `*View` its full page uses, under a header that links to that
/// page.
class DetailPaneHost extends StatelessWidget {
  const DetailPaneHost({
    required this.careerId,
    required this.target,
    this.placeholder,
    super.key,
  });

  static const Key fullProfileKey = Key('detailPane.fullProfile');

  final int careerId;
  final DetailTarget? target;

  /// What the empty pane says; [AppLocalizations.panePickPlayer] by default.
  /// A screen whose pane holds nations passes [AppLocalizations.panePickNation].
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = target;
    if (t == null) {
      return MasterDetailPlaceholder(text: placeholder ?? l.panePickPlayer);
    }
    final (title, route, body) = switch (t) {
      PlayerTarget(:final playerId) => (
        l.playerTitle,
        '${Routes.player}?careerId=$careerId&playerId=$playerId',
        PlayerView(
          // A new player is a new card: no scroll offset carried over.
          key: ValueKey(playerId),
          careerId: careerId,
          playerId: playerId,
        ),
      ),
      NationTarget(:final nationId) => (
        l.nationsVitrineTitle,
        '${Routes.nationVitrine}?careerId=$careerId&nationId=$nationId',
        NationView(
          // A new nation is a new record: no scroll offset carried over.
          key: ValueKey(('nation', nationId)),
          careerId: careerId,
          nationId: nationId,
        ),
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 34,
          color: AppColors.surfaceContainer,
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.capsIn(l.localeName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.panelTitle,
                ),
              ),
              TextButton(
                key: fullProfileKey,
                onPressed: () => context.push(route),
                child: Text(l.paneFullProfile, style: TabletText.panelLink),
              ),
            ],
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}

/// Shows a player: in the nearest detail pane when the screen has one,
/// otherwise on his own page, as every phone screen does.
///
/// From inside a sheet or dialog there is never a pane (see
/// [DetailPaneScope.maybeOf]); close the sheet BEFORE calling this.
void openPlayer(
  BuildContext context, {
  required int careerId,
  required int playerId,
}) {
  final pane = DetailPaneScope.maybeOf(context);
  if (pane != null) {
    pane.show(PlayerTarget(playerId));
    return;
  }
  unawaited(
    context.push('${Routes.player}?careerId=$careerId&playerId=$playerId'),
  );
}

/// Shows a nation's record: in the nearest detail pane when the screen has
/// one, otherwise on its own vitrine page, as every phone screen does.
///
/// From inside a sheet or dialog there is never a pane (see
/// [DetailPaneScope.maybeOf]); close the sheet BEFORE calling this.
void openNation(
  BuildContext context, {
  required int careerId,
  required int nationId,
}) {
  final pane = DetailPaneScope.maybeOf(context);
  if (pane != null) {
    pane.show(NationTarget(nationId));
    return;
  }
  unawaited(
    context.push(
      '${Routes.nationVitrine}?careerId=$careerId&nationId=$nationId',
    ),
  );
}
