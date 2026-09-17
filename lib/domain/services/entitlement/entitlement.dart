import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/entities/nation.dart';

/// Whether the premium upgrade (€12.99) is unlocked.
///
/// This is the single source of truth for all paywall gating — UI and data
/// code should consult it rather than scattering `if (premium)` checks.
///
/// Currently defaults to **unlocked** so everything is available for play/
/// testing. The EntitlementService still flips it from the cached grant and the
/// store's purchase stream, but the default already grants Pro. Flip back to
/// `false` to gate the free tier again.
final premiumUnlockedProvider = StateProvider<bool>((ref) => true);

/// Whether [nation] can currently be selected: free-demo nations are always
/// available; the rest require [premiumUnlocked].
bool nationSelectable(Nation nation, {required bool premiumUnlocked}) =>
    nation.isFreeDemo || premiumUnlocked;

/// Maximum number of concurrent save games: 3 on the free tier, 10 with Pro.
///
/// Three is enough to keep a second nation and an experiment alongside the
/// real save, which is what a manager wants before he has decided to buy; ten
/// is past anyone's need, which is the point of it.
int maxSaveSlots({required bool premiumUnlocked}) => premiumUnlocked ? 10 : 3;
