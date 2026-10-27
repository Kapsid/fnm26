import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/competition/window_friendlies.dart';

export 'package:fnm/domain/services/competition/window_friendlies.dart'
    show FriendlyResult;

/// Other nations' friendly results for the window the player just played their
/// friendly in: every free nation that arranged one (see [WindowFriendlies]),
/// deterministically generated (never persisted) so the same window always
/// reads the same. A nation with a competitive match in the window is busy and
/// plays no friendly. Returns an empty list when the player's most recent
/// match wasn't a friendly.
final AutoDisposeFutureProviderFamily<List<FriendlyResult>, int>
otherFriendliesProvider = FutureProvider.autoDispose
    .family<List<FriendlyResult>, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final comp = ref.watch(competitionRepositoryProvider);
      final fixtures = await comp.fixturesForNation(careerId, career.nationId);

      // The player's most recent played match must be a friendly.
      final played = fixtures.where((f) => f.hasResult).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      if (played.isEmpty || played.first.round != Rounds.friendly) {
        return const [];
      }
      final last = played.first;
      final opponentId = last.homeNationId == career.nationId
          ? last.awayNationId
          : last.homeNationId;

      // Whoever has a competitive match this window is busy with it.
      final windowStart = DateTime(last.date.year, last.date.month);
      final windowEnd = DateTime(last.date.year, last.date.month + 1);
      final busy = <int>{career.nationId, opponentId};
      for (final f in await comp.fixturesBetween(
        careerId,
        windowStart,
        windowEnd,
      )) {
        if (f.round == Rounds.friendly) continue;
        busy
          ..add(f.homeNationId)
          ..add(f.awayNationId);
      }

      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(careerId);
      return WindowFriendlies.generate(
        nations: nations,
        busyIds: busy,
        seed: career.rngSeed,
        // Keyed by the window (year/month), so the set is stable on revisit.
        windowKey: last.date.year * 13 + last.date.month,
      );
    });
