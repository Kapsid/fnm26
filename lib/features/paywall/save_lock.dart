import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/paywall/premium_gate_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Pro-locked saves: the app side of [saveNeedsPremium].
///
/// A save past the free cycle, or a Pro campaign run, cannot be OPENED
/// without Pro. Nothing here ever writes to a save: a locked one stays in the
/// list, exports and deletes as before, and opens the moment Pro is owned.
///
/// Every check answers "not locked" until the launch entitlement decision has
/// settled ([entitlementSettledProvider]): a premium flag still false because
/// the store has not answered yet is no evidence against anybody.

/// Whether [save] is Pro-locked, given its campaign [tag] (null for an
/// ordinary save) and the entitlement as it stands.
bool saveIsProLocked(
  Career save,
  CampaignTag? tag, {
  required bool premiumUnlocked,
  required bool settled,
}) =>
    settled &&
    saveNeedsPremium(
      cyclePointer: save.cyclePointer,
      premiumUnlocked: premiumUnlocked,
      proCampaign: tag?.def.needsPro ?? false,
    );

/// Whether career [careerId] is Pro-locked, read from the database.
///
/// Fails open: a career it cannot read, or a read that throws, is not locked.
Future<bool> careerIsProLocked({
  required CareerRepository careers,
  required CompetitionRepository competitions,
  required int careerId,
  required bool premiumUnlocked,
  required bool settled,
}) async {
  if (!settled || premiumUnlocked) return false;
  try {
    final career = await careers.byId(careerId);
    if (career == null) return false;
    final tag = (await campaignTags(competitions))[careerId];
    return saveIsProLocked(
      career,
      tag,
      premiumUnlocked: premiumUnlocked,
      settled: settled,
    );
  } on Object {
    return false;
  }
}

/// The ids of every Pro-locked career (saves and campaign runs alike). Empty
/// while the entitlement is unsettled or Pro is owned, so a purchase or a
/// restore unlocks every tile on the spot.
final AutoDisposeFutureProvider<Set<int>> lockedCareerIdsProvider =
    FutureProvider.autoDispose<Set<int>>((ref) async {
      final premium = ref.watch(premiumUnlockedProvider);
      final settled = ref.watch(entitlementSettledProvider);
      if (!settled || premium) return const <int>{};
      // Watched so a new, deleted, imported or rolled save is re-read.
      await ref.watch(savesProvider.future);
      await ref.watch(campaignRunsProvider.future);
      final tags = await campaignTags(ref.read(competitionRepositoryProvider));
      return {
        for (final c in await ref.read(careerRepositoryProvider).all())
          if (saveIsProLocked(
            c,
            tags[c.id],
            premiumUnlocked: premium,
            settled: settled,
          ))
            c.id,
      };
    });

/// [lockedCareerIdsProvider] for a build. Subscribes only while a lock is
/// possible at all (settled, and no Pro), so a paying player's screens, and
/// every test that never settles the entitlement, hold no extra provider.
Set<int> watchLockedCareerIds(WidgetRef ref) {
  final mayLock =
      ref.watch(entitlementSettledProvider) &&
      !ref.watch(premiumUnlockedProvider);
  if (!mayLock) return const <int>{};
  return ref.watch(lockedCareerIdsProvider).valueOrNull ?? const <int>{};
}

/// Whether one career is Pro-locked, for a screen inside it (the hub): it
/// re-answers the moment the entitlement settles or changes.
final AutoDisposeFutureProviderFamily<bool, int> careerProLockedProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, careerId) async {
      final premium = ref.watch(premiumUnlockedProvider);
      final settled = ref.watch(entitlementSettledProvider);
      // No database is touched unless the answer could be "locked".
      if (!settled || premium) return false;
      return careerIsProLocked(
        careers: ref.read(careerRepositoryProvider),
        competitions: ref.read(competitionRepositoryProvider),
        careerId: careerId,
        premiumUnlocked: premium,
        settled: settled,
      );
    });

/// Where [Routes.saveLocked] sends a manager for career [careerId].
String saveLockedLocation(int careerId) =>
    '${Routes.saveLocked}?careerId=$careerId';

/// The router's one choke point: any route into a save (every one carries
/// `?careerId=`) for a Pro-locked career goes to the gate instead.
///
/// Synchronous, with no database read, whenever the answer cannot be "locked"
/// (unsettled, Pro owned, no career in the route, the gate itself), which is
/// every navigation for a paying player and every one in a test that never
/// settles the entitlement.
FutureOr<String?> proLockRedirect(Ref ref, Uri uri) {
  if (uri.path == Routes.saveLocked) return null;
  final raw = uri.queryParameters['careerId'];
  if (raw == null) return null;
  if (!ref.read(entitlementSettledProvider) ||
      ref.read(premiumUnlockedProvider)) {
    return null;
  }
  final id = int.tryParse(raw);
  if (id == null) return null;
  return careerIsProLocked(
    careers: ref.read(careerRepositoryProvider),
    competitions: ref.read(competitionRepositoryProvider),
    careerId: id,
    premiumUnlocked: false,
    settled: true,
  ).then((locked) => locked ? saveLockedLocation(id) : null);
}

/// The gate a Pro-locked save opens to: the end-of-trial wall, worded for a
/// save. Buying or restoring Pro opens the save; leaving goes back to where
/// saves (or campaign runs) are listed.
class SaveLockedScreen extends ConsumerWidget {
  const SaveLockedScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read now, so the answer is in hand by the time "Exit" is tapped.
    final campaign = ref.watch(campaignOfProvider(careerId)).valueOrNull;
    void done({required bool bought}) {
      if (!context.mounted) return;
      if (bought) {
        unawaited(ref.read(careerServiceProvider).markPlayed(careerId));
        context.go('${Routes.hub}?careerId=$careerId');
      } else {
        final run = campaign != null && !campaign.moved;
        context.go(run ? Routes.campaigns : Routes.saves);
      }
    }

    // Pro already owned (it landed before this page was built, which the
    // gate's own listener would never hear): straight on into the save.
    if (ref.read(premiumUnlockedProvider)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ref.read(premiumUnlockedProvider)) done(bought: true);
      });
    }
    return PremiumGateScreen(
      fromSave: true,
      onResult: (bought) => done(bought: bought),
    );
  }
}

/// Sends a manager sitting inside a save that has just become Pro-locked
/// (the purchase refunded mid-session, or the entitlement settling after he
/// was quicker than the store) to the gate. Put once in the hub: the next hub
/// build is soon enough, and a match in progress is never torn down.
void watchProLock(BuildContext context, WidgetRef ref, int careerId) {
  final locked =
      ref.watch(careerProLockedProvider(careerId)).valueOrNull ?? false;
  if (!locked) return;
  // After the frame: this runs inside a build. Asked again there, so a
  // purchase or restore landing in between does not send an owner to a gate.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    if (ref.read(premiumUnlockedProvider) ||
        !ref.read(entitlementSettledProvider)) {
      return;
    }
    context.go(saveLockedLocation(careerId));
  });
}

/// Opens career [careerId] where the manager left it, or its gate when it is
/// Pro-locked. Only an open save is stamped as played: a locked one is not
/// touched at all.
///
/// Synchronous whenever it cannot be locked (unsettled, or Pro owned), so the
/// common tap goes straight through with nothing awaited.
void openSave(BuildContext context, WidgetRef ref, int careerId) {
  void open() {
    unawaited(ref.read(careerServiceProvider).markPlayed(careerId));
    context.go('${Routes.hub}?careerId=$careerId');
  }

  final premium = ref.read(premiumUnlockedProvider);
  final settled = ref.read(entitlementSettledProvider);
  if (!settled || premium) return open();
  unawaited(
    careerIsProLocked(
      careers: ref.read(careerRepositoryProvider),
      competitions: ref.read(competitionRepositoryProvider),
      careerId: careerId,
      premiumUnlocked: premium,
      settled: settled,
    ).then((locked) {
      if (!context.mounted) return;
      if (locked) {
        context.go(saveLockedLocation(careerId));
      } else {
        open();
      }
    }),
  );
}

/// The one-line padlock note a Pro-locked save wears, on the saves list and
/// the home card alike. Wraps rather than cuts: it is the reason the save
/// will not open.
class SaveLockedNote extends StatelessWidget {
  const SaveLockedNote({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.lock_rounded, size: 12, color: AppColors.warning),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            AppLocalizations.of(context).careerSaveLockedNote,
            style: AppTypography.labelSmall.copyWith(color: AppColors.warning),
          ),
        ),
      ],
    ),
  );
}
