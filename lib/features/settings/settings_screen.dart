import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/contact.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/paywall/save_lock.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/features/settings/backups_card.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

part 'settings_tablet_layout.dart';

/// Each language in its own tongue, never translated: a manager who has landed
/// in a language he cannot read must still be able to find his own.
const Map<String, String> _languageEndonyms = {
  'en': 'English',
  'cs': 'Čeština',
  'fr': 'Français',
  'it': 'Italiano',
  'pl': 'Polski',
  'es': 'Español',
  'de': 'Deutsch',
  'pt': 'Português',
  'tr': 'Türkçe',
  'nl': 'Nederlands',
  'id': 'Bahasa Indonesia',
  'el': 'Ελληνικά',
  'sv': 'Svenska',
  'nb': 'Norsk bokmål',
  'vi': 'Tiếng Việt',
  'bg': 'Български',
  'da': 'Dansk',
  'fi': 'Suomi',
  'hu': 'Magyar',
  'hr': 'Hrvatski',
  'uk': 'Українська',
  'fil': 'Filipino',
  'hi': 'हिन्दी',
  'ja': '日本語',
  'ko': '한국어',
  'ro': 'Română',
  'th': 'ไทย',
  'ms': 'Bahasa Melayu',
};

/// Opens the language picker: "System" plus one radio row per language.
Future<void> _pickLanguage(
  BuildContext context,
  WidgetRef ref,
  String current,
) async {
  final l = AppLocalizations.of(context);
  final chosen = await showAdaptiveSheet<String>(
    context: context,
    isScrollControlled: true,
    // Capped well short of the screen: with twenty-odd languages a
    // full-height sheet left no barrier to tap away and no hint of the rows
    // below the fold. A header with a close button and an always-visible
    // scrollbar make both plain.
    builder: (ctx) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(ctx).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.xs,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.settingsLanguageTitle,
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  IconButton(
                    key: const Key('language-sheet-close'),
                    tooltip: MaterialLocalizations.of(ctx).closeButtonTooltip,
                    icon: const Icon(Icons.close, color: AppColors.primary),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: _LanguageOptions(
                current: current,
                options: [
                  ('system', l.settingsLanguageSystem),
                  for (final e in _languageEndonyms.entries) (e.key, e.value),
                ],
                onPick: (v) => Navigator.of(ctx).pop(v),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  if (chosen == null) return;
  setLocale(ref, chosen == 'system' ? null : Locale(chosen));
}

/// Radio rows built from ListTiles, so the whole row is the tap target.
class _LanguageOptions extends StatelessWidget {
  const _LanguageOptions({
    required this.current,
    required this.options,
    required this.onPick,
  });

  final String current;
  final List<(String, String)> options;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) => Scrollbar(
    thumbVisibility: true,
    child: ListView(
      key: const Key('language-sheet-list'),
      shrinkWrap: true,
      primary: true,
      children: [
        for (final (code, label) in options)
          ListTile(
            key: Key('language-option-$code'),
            leading: Icon(
              code == current
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: AppColors.primary,
            ),
            title: Text(label, style: AppTypography.bodyMedium),
            onTap: () => onPick(code),
          ),
      ],
    ),
  );
}

/// App settings: the sound-and-haptics toggle for match cues and the UI
/// language selector.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const Key tabletLayoutKey = Key('settings.tabletLayout');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (useTabletLayout(context, ref)) return const _SettingsTabletLayout();
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          // Settings is opened with go() (which replaces the route), so pop
          // back if we can, else return to the home screen.
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
        ),
        title: Text(
          l.settingsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        // A ListView given its own padding drops the safe-area inset it would
        // otherwise add, so on edge-to-edge Android the last card (Restore
        // from file) sat under the system navigation bar. Add it back.
        padding: EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.marginMobile,
          AppSpacing.marginMobile,
          AppSpacing.marginMobile + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: const [
          _SoundHapticsCard(),
          SizedBox(height: AppSpacing.md),
          _LanguageCard(),
          SizedBox(height: AppSpacing.md),
          _TextSizeCard(),
          SizedBox(height: AppSpacing.md),
          _FreeScopeCard(),
          SizedBox(height: AppSpacing.md),
          _FromDeveloperCard(),
          SizedBox(height: AppSpacing.md),
          _TourCard(),
          SizedBox(height: AppSpacing.md),
          BackupsCard(),
          SizedBox(height: AppSpacing.md),
          _DiagnosticsCard(),
          SizedBox(height: AppSpacing.md),
          _ContactCard(),
          SizedBox(height: AppSpacing.md),
          CommunityCard(),
        ],
      ),
    );
  }
}

/// Sound and haptics for match cues, on or off.
class _SoundHapticsCard extends ConsumerWidget {
  const _SoundHapticsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final soundHaptics = ref.watch(soundHapticsEnabledProvider);
    return AppCard(
      padding: EdgeInsets.zero,
      child: SwitchListTile(
        value: soundHaptics,
        onChanged: (v) => setSoundHaptics(ref, v),
        activeColor: AppColors.primary,
        title: Text(
          l.settingsSoundHapticsTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          l.settingsSoundHapticsBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        secondary: const Icon(
          Icons.vibration_rounded,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// The UI language: the device's, or one forced.
class _LanguageCard extends ConsumerWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // 'system' when there is no override, otherwise the forced language code.
    final current = ref.watch(localeProvider)?.languageCode ?? 'system';
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        key: const Key('settings-language-tile'),
        leading: const Icon(
          Icons.translate_rounded,
          color: AppColors.primary,
        ),
        title: Text(
          l.settingsLanguageTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          l.settingsLanguageBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current == 'system'
                  ? l.settingsLanguageSystem
                  : _languageEndonyms[current] ?? current,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.primary,
            ),
          ],
        ),
        onTap: () => _pickLanguage(context, ref, current),
      ),
    );
  }
}

/// How big the app's text is drawn: normal, large or larger, on top of the
/// phone's own text scale. Chips in a Wrap rather than a segmented row, so a
/// long translation at the largest size moves to a second line instead of
/// overflowing.
class _TextSizeCard extends ConsumerWidget {
  const _TextSizeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final current = ref.watch(textSizeProvider);
    String label(TextSize t) => switch (t) {
      TextSize.normal => l.settingsTextSizeNormal,
      TextSize.large => l.settingsTextSizeLarge,
      TextSize.larger => l.settingsTextSizeLarger,
    };
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            key: const Key('settings-text-size-tile'),
            leading: const Icon(
              Icons.format_size_rounded,
              color: AppColors.primary,
            ),
            title: Text(
              l.settingsTextSizeTitle,
              style: AppTypography.bodyMedium,
            ),
            subtitle: Text(
              l.settingsTextSizeBlurb,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final t in TextSize.values)
                  ChoiceChip(
                    key: Key('settings-text-size-${t.name}'),
                    label: Text(label(t)),
                    selected: current == t,
                    onSelected: (_) => setTextSize(ref, t),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// What the free game covers, stated plainly and stated ONCE, here.
///
/// Deliberately not on the hub, not before a tournament, and not on the way
/// into a save: a manager on his first day is being asked to care about a
/// nation, not about a price, and putting the terms in front of him there
/// costs the people who would have stayed. The trade is that the gate
/// arrives at the first rollover without a run-up — this page is where
/// somebody who wants to know can find out, and it is the whole of the
/// disclosure.
class _FreeScopeCard extends ConsumerWidget {
  const _FreeScopeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final premium = ref.watch(premiumUnlockedProvider);
    return AppCard(
      // Tapping it opens the paywall, which is where "Restore
      // purchases" lives. A manager who paid on his old phone needs a
      // way to say so that does not involve finishing a whole cycle
      // first, and Apple requires a visible restore control for a
      // non-consumable.
      onTap: () => unawaited(showPaywall(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            premium ? Icons.verified_rounded : Icons.lock_open_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  premium ? l.settingsUnlockedTitle : l.settingsFreeScopeTitle,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  premium ? l.settingsUnlockedBlurb : l.settingsFreeScopeBlurb,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The developer's note, in his own voice, for everyone. A manager who has
/// not bought gets the ask; one who has gets a thank-you instead, so nobody
/// is asked twice.
class _FromDeveloperCard extends ConsumerWidget {
  const _FromDeveloperCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final premium = ref.watch(premiumUnlockedProvider);
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.settingsFromDeveloperTitle,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  premium
                      ? l.settingsFromDeveloperThanksBlurb
                      : l.settingsFromDeveloperBlurb,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The way back into the walk through. It is offered once ever, so without
/// this a manager who said "no thanks" on his first day would have no way of
/// ever changing his mind.
///
/// It walks the save he played last, because the tour navigates real screens
/// and every one of them needs a save to show. With no save at all there is
/// nothing to walk, and the row says so rather than starting a tour of empty
/// rooms.
class _TourCard extends ConsumerWidget {
  const _TourCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // The save to walk: the one played most recently, or the newest if none
    // has ever been opened.
    // A Pro-locked save cannot be walked: the tour would only meet its gate.
    final lockedIds = watchLockedCareerIds(ref);
    final saves = [
      for (final s in ref.watch(savesProvider).valueOrNull ?? const <Career>[])
        if (!lockedIds.contains(s.id)) s,
    ];
    final replayable = saves.isEmpty
        ? null
        : (saves.toList()..sort((a, b) {
                final at = a.lastPlayedAt ?? a.createdAt;
                final bt = b.lastPlayedAt ?? b.createdAt;
                return bt.compareTo(at);
              }))
              .first;
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        enabled: replayable != null,
        onTap: replayable == null
            ? null
            : () {
                startTour(ref, replayable.id);
                context.go('${Routes.hub}?careerId=${replayable.id}');
              },
        leading: const Icon(
          Icons.school_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          l.settingsTourTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          replayable == null ? l.settingsTourNoSave : l.settingsTourBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// The on-device error log.
class _DiagnosticsCard extends StatelessWidget {
  const _DiagnosticsCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: () => context.push(Routes.diagnostics),
        leading: const Icon(
          Icons.bug_report_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          l.settingsDiagnosticsTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          l.settingsDiagnosticsBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Reaching the person who made the game.
///
/// Tapping COPIES the address rather than opening a mail app: a phone with no
/// mail account configured swallows a `mailto:` and leaves the manager
/// looking at nothing, while the clipboard always works and the address is
/// what they actually need.
class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: () async {
          await Clipboard.setData(const ClipboardData(text: kContactEmail));
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.settingsContactCopied)));
        },
        leading: const Icon(Icons.alternate_email, color: AppColors.primary),
        title: Text(l.settingsContactTitle, style: AppTypography.bodyMedium),
        subtitle: Text(
          kContactEmail,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.copy_rounded,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Opens [url] outside the app; false when nothing could. A provider so a
/// test can stand in for the platform.
final linkLauncherProvider = Provider<Future<bool> Function(Uri url)>(
  (ref) =>
      (url) => launchUrl(url, mode: LaunchMode.externalApplication),
);

/// Where managers gather: the Discord and the Instagram account. Tapping
/// opens the link in the browser or app; if the phone cannot (or it throws),
/// the link is copied instead, as the contact card does.
class CommunityCard extends ConsumerWidget {
  const CommunityCard({super.key});

  static const Key discordKey = Key('settings.discord');
  static const Key instagramKey = Key('settings.instagram');

  Future<void> _open(BuildContext context, WidgetRef ref, String url) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await ref.read(linkLauncherProvider)(Uri.parse(url));
    } on Object {
      opened = false;
    }
    if (opened) return;
    await Clipboard.setData(ClipboardData(text: url));
    messenger.showSnackBar(SnackBar(content: Text(l.settingsLinkCopied)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sub = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: Text(
              l.settingsCommunityTitle,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          ListTile(
            key: discordKey,
            onTap: () => _open(context, ref, kDiscordUrl),
            leading: const Icon(Icons.forum_outlined, color: AppColors.primary),
            title: const Text('Discord', style: AppTypography.bodyMedium),
            subtitle: Text(l.settingsDiscordSubtitle, style: sub),
            trailing: const Icon(
              Icons.open_in_new,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          ListTile(
            key: instagramKey,
            onTap: () => _open(context, ref, kInstagramUrl),
            leading: const Icon(
              Icons.photo_camera_outlined,
              color: AppColors.primary,
            ),
            title: const Text('Instagram', style: AppTypography.bodyMedium),
            subtitle: Text(kInstagramHandle, style: sub),
            trailing: const Icon(
              Icons.open_in_new,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
