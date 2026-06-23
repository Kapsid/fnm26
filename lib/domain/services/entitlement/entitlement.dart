import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/entities/nation.dart';

/// Whether the premium upgrade (€9.99) is unlocked.
///
/// This is the single source of truth for all paywall gating — UI and data
/// code should consult it rather than scattering `if (premium)` checks.
///
/// During development it defaults to **unlocked** so every nation/feature is
/// available. M7 will drive this from the real `in_app_purchase` flow plus a
/// persisted entitlement flag (and restore-purchases).
final premiumUnlockedProvider = StateProvider<bool>((ref) => true);

/// Whether [nation] can currently be selected: free-demo nations are always
/// available; the rest require [premiumUnlocked].
bool nationSelectable(Nation nation, {required bool premiumUnlocked}) =>
    nation.isFreeDemo || premiumUnlocked;

/// Maximum number of concurrent save games: 2 on the free tier, 5 with Pro.
int maxSaveSlots({required bool premiumUnlocked}) => premiumUnlocked ? 5 : 2;
