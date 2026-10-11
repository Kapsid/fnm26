import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:fnm/shared/widgets/flag_disc.dart';
import 'package:go_router/go_router.dart';

/// The inbox badge's text: the count, capped so a long-ignored inbox does not
/// grow a pill wider than the icon it sits on.
String unreadBadgeLabel(int unread) => unread > 99 ? '99+' : '$unread';

/// The top bar's team colours: a faint wash of the managed nation's colour
/// over the bar's own surface, strongest behind the flag and the name, and a
/// thin strip of the colour itself along the bottom edge.
///
/// The colour is the shirt's (the nation's `primaryColor`). A white or black
/// shirt has no colour to wash with (white into near-black is a dirty grey),
/// so the trim is used when it is a real colour, as England's navy; a kit with
/// no colour at all (Germany's white and black) keeps the plain surface and
/// gets only the strip, in a clean light grey.
class TopBarTint {
  const TopBarTint._(this.start, this.end, this.strip);

  /// The kit as the bar wears it.
  factory TopBarTint.of(String primaryHex, String secondaryHex) {
    final shirt = KitColors.parse(primaryHex);
    final trim = KitColors.parse(secondaryHex);
    final lead = _colourful(shirt)
        ? shirt
        : _colourful(trim)
        ? trim
        : null;
    if (lead == null) {
      final light = KitColors.accent(primaryHex, secondaryHex);
      return TopBarTint._(_base, _base, light);
    }
    final strip = KitColors.legible(lead);
    // A bright colour (yellow above all) darkened this far turns olive: it
    // washes in at up to half strength, a deep red or navy at nearly full.
    final damp = 1 - 0.5 * strip.computeLuminance();
    return TopBarTint._(
      Color.lerp(_base, strip, _startWeight * damp)!,
      Color.lerp(_base, strip, _endWeight * damp)!,
      strip,
    );
  }

  /// No nation (still loading): the bar as it always was, no strip.
  static const TopBarTint none = TopBarTint._(_base, _base, null);

  static const Color _base = AppColors.surfaceContainerLowest;

  /// How much of the team colour is mixed in, at the left and right ends.
  static const double _startWeight = 0.14;
  static const double _endWeight = 0.08;

  /// How thick the strip along the bottom is.
  static const double stripWidth = 3;

  /// The fill at the bar's left end, behind the flag.
  final Color start;

  /// The fill at the bar's right end, behind the event button.
  final Color end;

  /// The strip along the bottom edge; null draws none.
  final Color? strip;

  static bool _colourful(Color c) {
    final h = HSLColor.fromColor(c);
    return h.saturation >= 0.15 && h.lightness > 0.08 && h.lightness < 0.92;
  }

  BoxDecoration get decoration => BoxDecoration(
    gradient: start == end ? null : LinearGradient(colors: [start, end]),
    color: start == end ? start : null,
    // Always there, see-through until a nation is known: the border is part
    // of the padding, and a strip arriving with the nation would otherwise
    // nudge the whole row up as the save loads.
    border: Border(
      bottom: BorderSide(
        color: strip ?? const Color(0x00000000),
        width: stripWidth,
      ),
    ),
  );
}

/// The bar across the top of every in-save tablet screen: who you are, what
/// day it is, what is next, and the button that moves the world on.
class TabletTopBar extends ConsumerWidget {
  const TabletTopBar({required this.careerId, super.key});

  static const double height = 64;

  /// The bar itself, whose decoration carries the team colours.
  static const Key barKey = ValueKey('tabletTopBar.bar');

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final hub = ref.watch(hubDataProvider(careerId)).valueOrNull;
    final unread = ref.watch(unreadMessagesProvider(careerId)).valueOrNull ?? 0;
    final nation = hub?.nations[hub.career.nationId];
    final next = hub?.next;
    final tint = nation == null
        ? TopBarTint.none
        : TopBarTint.of(nation.primaryColor, nation.secondaryColor);
    return Container(
      key: barKey,
      height: height,
      decoration: tint.decoration,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          if (nation != null) ...[
            FlagDisc(nation.code, size: 28),
            const SizedBox(width: AppSpacing.sm),
            // Capped, and ellipsised: "Saint Vincent and the Grenadines" must
            // not push the date and the next fixture off the bar.
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                nation.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TabletText.barTitle,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
          ],
          if (hub != null)
            Text(
              AppDate.dayMonthYear(context, hub.career.inGameDate),
              style: TabletText.barMeta,
            ),
          // The chip takes ALL the free space and sits at its left. Sharing
          // it with a Spacer gave it half, and it ellipsised long before the
          // bar was full.
          if (hub != null && next != null) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _NextChip(hub: hub, next: next),
              ),
            ),
          ] else
            const Spacer(),
          IconButton(
            tooltip: l.hubMessages,
            onPressed: () =>
                context.go('${Routes.messages}?careerId=$careerId'),
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text(unreadBadgeLabel(unread)),
              child: const Icon(Icons.mail_outline, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 260,
            child: HubEventButton(
              careerId: careerId,
              compact: true,
              tourTarget: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextChip extends StatelessWidget {
  const _NextChip({required this.hub, required this.next});

  final HubData hub;
  final Fixture next;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String name(int id) => hub.nations[id]?.name ?? l.hubUnknown;
    // The hub keeps the opponent back until the draw has been watched; the
    // top bar must not give it away first.
    final teams = hub.nextDrawWatched
        ? '${name(next.homeNationId)} ${l.hubVs.toLowerCase()} '
              '${name(next.awayNationId)}'
        : l.topBarDrawPending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${l.topBarNext}  ', style: TabletText.barMeta),
            TextSpan(text: teams, style: TabletText.barStrong),
            TextSpan(
              text:
                  '  ${MatchStage.labelCompact(l, next)}, '
                  '${AppDate.dayMonth(context, next.date)}',
              style: TabletText.barMeta,
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
