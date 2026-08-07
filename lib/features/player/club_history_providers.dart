import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/club/club_history.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// Which player, in which save.
typedef ClubHistoryArg = ({int careerId, int playerId});

/// A player's club career, oldest spell first.
///
/// Rebuilt by resolving the player once per season of the save so far and
/// reading the club each rating implied — the same derivation every squad list
/// uses, with the same development inputs, so the newest spell is always the
/// club shown at the top of the card rather than a second opinion about it.
final AutoDisposeFutureProviderFamily<List<ClubSpell>, ClubHistoryArg>
clubHistoryProvider =
    FutureProvider.autoDispose.family<List<ClubSpell>, ClubHistoryArg>((
  ref,
  arg,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(arg.careerId);
  if (career == null) return const [];
  final repo = ref.watch(playerRepositoryProvider);
  final years = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(arg.careerId).future);
  final starts = await ref.watch(careerDevBonusProvider(arg.careerId).future);

  final seasons = <({int year, String club, String country})>[];
  for (var y = 0; y <= years; y++) {
    final p = await repo.byId(
      arg.playerId,
      agingYears: y,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: starts,
    );
    // Null before a newgen has come through — his career simply starts later.
    if (p == null) continue;
    seasons.add((
      year: CareerService.cycleStart.year + y,
      club: p.club,
      country: p.clubCountry,
    ));
  }
  return ClubHistory.spells(seasons);
});
