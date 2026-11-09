import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';
import 'package:fnm/domain/services/world_managers/manager_reputation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';

/// The world managers of every career (see [WorldManagerService]). Kept for
/// the app's life, so a career's seeding is shared by all who ask.
final worldManagerServiceProvider = Provider<WorldManagerService>(
  WorldManagerService.new,
);

/// Whether the AI's tactics read the world manager in charge (see
/// [WorldManagerService.styleOn]). Always on in the app; a test switches it
/// off to replay a world exactly as it was before world managers.
final worldManagerStyleEnabledProvider = Provider<bool>((_) => true);

/// The nations the player has led: every cycle's in [stints], and the one
/// he leads now ([current]).
Set<int> playerNationsOf(Map<int, int> stints, int current) => {
  ...stints.values,
  current,
};

/// The player's relation with manager [managerId], from what a reader has
/// already loaded: the career's [spells] and [ties] (any manager's; his are
/// picked out), the fixtures of every nation the player has led
/// ([playerFixtures], see [playerNationsOf]), his [stints] and the nation he
/// leads now. The one derivation every reader shares, so the news, the
/// press and Y all read the same label for the same man.
ManagerRelation relationWithPlayer({
  required int managerId,
  required List<ManagerSpell> spells,
  required List<ManagerTie> ties,
  required List<Fixture> playerFixtures,
  required Map<int, int> stints,
  required int currentNationId,
  required DateTime today,
}) => readRelation(
  spells: [
    for (final sp in spells)
      if (sp.managerId == managerId) sp,
  ],
  meetings: playerFixtures,
  playerSideAt: (d) => {
    stints[CareerService.cycleForYear(d.year)] ?? currentNationId,
  },
  ties: [
    for (final t in ties)
      if (t.managerId == managerId) t,
  ],
  today: today,
);

/// The player's relation with one world manager, derived on read. Read only
/// by the screens that show it, never by a hub, career-load or careers-list
/// provider.
///
/// Reads: his spells, the career's ties, and the player's own fixtures in
/// one query (a meeting counts only if the player was in it).
final AutoDisposeFutureProviderFamily<
  ManagerRelation,
  ({int careerId, int managerId})
>
managerRelationProvider = FutureProvider.autoDispose
    .family<ManagerRelation, ({int careerId, int managerId})>((ref, key) async {
      final repo = ref.read(worldManagerRepositoryProvider);
      final career = await ref
          .read(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) {
        return (
          warmth: 0,
          label: TieLabel.neutral,
          meetings: 0,
          won: 0,
          drawn: 0,
          lost: 0,
        );
      }
      final stints = await ref
          .read(careerRepositoryProvider)
          .stints(key.careerId);
      return relationWithPlayer(
        managerId: key.managerId,
        spells: await repo.spellsOf(key.careerId, key.managerId),
        ties: await repo.ties(key.careerId),
        playerFixtures: await ref
            .read(competitionRepositoryProvider)
            .fixturesForNations(
              key.careerId,
              playerNationsOf(stints, career.nationId),
            ),
        stints: stints,
        currentNationId: career.nationId,
        today: career.inGameDate,
      );
    });

/// A nation's manager as a screen shows him: who, his spell, his age and the
/// nation's record under him (the fixtures inside the spell).
typedef NationManagerView = ({
  WorldManager m,
  ManagerSpell spell,
  int age,
  int won,
  int drawn,
  int lost,
});

Future<NationManagerView?> _viewOf(
  Ref ref,
  int careerId,
  int nationId,
  DateTime date,
) async {
  final repo = ref.read(worldManagerRepositoryProvider);
  final spell = await repo.inChargeOn(careerId, nationId, date);
  if (spell == null) return null;
  final m = await repo.managerById(careerId, spell.managerId);
  if (m == null) return null;
  final r = await _spellResults(ref, careerId, spell);
  return (
    m: m,
    spell: spell,
    age: date.year - m.birthYear,
    won: r.won,
    drawn: r.drawn,
    lost: r.lost,
  );
}

/// The nation's results inside [spell]: the fixtures played between its
/// first and last day.
Future<({int won, int drawn, int lost})> _spellResults(
  Ref ref,
  int careerId,
  ManagerSpell spell,
) async {
  final fixtures = await ref
      .read(competitionRepositoryProvider)
      .fixturesForNationBetween(
        careerId,
        spell.nationId,
        spell.fromDate,
        spell.toDate,
      );
  return wdlOf(fixtures, spell.nationId);
}

/// [nationId]'s wins, draws and losses among the played [fixtures].
({int won, int drawn, int lost}) wdlOf(List<Fixture> fixtures, int nationId) {
  var won = 0;
  var drawn = 0;
  var lost = 0;
  for (final f in fixtures) {
    if (!f.hasResult) continue;
    final mine = f.homeNationId == nationId ? f.homeScore! : f.awayScore!;
    final theirs = f.homeNationId == nationId ? f.awayScore! : f.homeScore!;
    if (mine > theirs) {
      won++;
    } else if (mine == theirs) {
      drawn++;
    } else {
      lost++;
    }
  }
  return (won: won, drawn: drawn, lost: lost);
}

/// The manager in charge of a nation today, for the nation page. This is the
/// first thing that seeds a career's managers (lazily, see
/// [WorldManagerService.ensureSeeded]); a cycle without world managers, or
/// the player's own nation, has none.
final AutoDisposeFutureProviderFamily<
  NationManagerView?,
  ({int careerId, int nationId})
>
nationManagerProvider = FutureProvider.autoDispose
    .family<NationManagerView?, ({int careerId, int nationId})>((
      ref,
      key,
    ) async {
      final career = await ref
          .read(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null || career.nationId == key.nationId) return null;
      final service = ref.read(worldManagerServiceProvider);
      if (!await service.cycleHasManagers(key.careerId, career.inGameDate)) {
        return null;
      }
      await service.ensureSeeded(key.careerId);
      return _viewOf(ref, key.careerId, key.nationId, career.inGameDate);
    });

/// The manager in charge of a nation on a fixture's date, for the match
/// preview. A date in a cycle without world managers reads none and seeds
/// nothing, so the preview is no slower there.
final AutoDisposeFutureProviderFamily<
  NationManagerView?,
  ({int careerId, int nationId, DateTime date})
>
opponentManagerProvider = FutureProvider.autoDispose
    .family<NationManagerView?, ({int careerId, int nationId, DateTime date})>((
      ref,
      key,
    ) async {
      final service = ref.read(worldManagerServiceProvider);
      if (!await service.cycleHasManagers(key.careerId, key.date)) return null;
      await service.ensureSeeded(key.careerId);
      return _viewOf(ref, key.careerId, key.nationId, key.date);
    });

/// A manager's profile: his spells, the player's relation with him and his
/// reputation today.
typedef ManagerProfile = ({
  WorldManager m,
  List<ManagerSpell> spells,
  ManagerRelation relation,
  int reputation,
  int age,
});

final AutoDisposeFutureProviderFamily<
  ManagerProfile,
  ({int careerId, int managerId})
>
managerProfileProvider = FutureProvider.autoDispose
    .family<ManagerProfile, ({int careerId, int managerId})>((ref, key) async {
      final repo = ref.read(worldManagerRepositoryProvider);
      final m = await repo.managerById(key.careerId, key.managerId);
      if (m == null) throw StateError('no manager ${key.managerId}');
      final spells = await repo.spellsOf(key.careerId, key.managerId);
      final career = await ref
          .read(careerRepositoryProvider)
          .byId(key.careerId);
      final today = career?.inGameDate ?? DateTime.now();
      final nations = await ref
          .read(nationRepositoryProvider)
          .forCareer(key.careerId);
      final world = ManagerWorld(managers: [m], spells: spells);
      final honours = WorldManagerService.honoursByManager(
        await ref.read(competitionRepositoryProvider).honours(key.careerId),
        world,
      );
      return (
        m: m,
        spells: spells,
        relation: await ref.watch(managerRelationProvider(key).future),
        age: today.year - m.birthYear,
        reputation: ManagerReputation.of(
          m.managerId,
          world,
          {for (final Nation n in nations) n.id: n.ranking},
          honours,
          asOf: today,
        ),
      );
    });

/// The career's nations by id, for the names a profile lists.
final AutoDisposeFutureProviderFamily<Map<int, Nation>, int>
managerNationsProvider = FutureProvider.autoDispose
    .family<Map<int, Nation>, int>(
      (ref, careerId) async => {
        for (final n
            in await ref.read(nationRepositoryProvider).forCareer(careerId))
          n.id: n,
      },
    );

/// One spell of a manager's career as his page lists it: the nation's
/// results inside it and the titles it won.
typedef ManagerSpellRecord = ({
  ManagerSpell spell,
  int won,
  int drawn,
  int lost,
  int trophies,
});

/// A manager's full page: his profile ([managerProfileProvider]), every
/// spell with its record, newest first, and the nation he is from.
typedef ManagerDetail = ({
  ManagerProfile profile,
  List<ManagerSpellRecord> spells,
  Nation? homeland,
});

/// A manager's page, derived on read from his stored spells, the fixtures
/// inside them and the roll of honour. Null when the career has no manager
/// of that id (an old link, or a cycle without world managers).
final AutoDisposeFutureProviderFamily<
  ManagerDetail?,
  ({int careerId, int managerId})
>
managerDetailProvider = FutureProvider.autoDispose
    .family<ManagerDetail?, ({int careerId, int managerId})>((ref, key) async {
      final career = await ref
          .read(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) return null;
      final service = ref.read(worldManagerServiceProvider);
      if (await service.cycleHasManagers(key.careerId, career.inGameDate)) {
        await service.ensureSeeded(key.careerId);
      }
      final repo = ref.read(worldManagerRepositoryProvider);
      final m = await repo.managerById(key.careerId, key.managerId);
      if (m == null) return null;
      final profile = await ref.watch(managerProfileProvider(key).future);
      final trophies = WorldManagerService.honoursBySpell(
        await ref.read(competitionRepositoryProvider).honours(key.careerId),
        ManagerWorld(managers: [m], spells: profile.spells),
      );
      final spells = [...profile.spells]
        ..sort((a, b) {
          final c = b.fromDate.compareTo(a.fromDate);
          return c != 0 ? c : b.spellNo.compareTo(a.spellNo);
        });
      final records = <ManagerSpellRecord>[];
      for (final s in spells) {
        final r = await _spellResults(ref, key.careerId, s);
        records.add((
          spell: s,
          won: r.won,
          drawn: r.drawn,
          lost: r.lost,
          trophies: trophies[s.spellNo] ?? 0,
        ));
      }
      final nations = await ref.watch(
        managerNationsProvider(key.careerId).future,
      );
      Nation? homeland;
      for (final n in nations.values) {
        if (n.code.toUpperCase() == m.nationality.toUpperCase()) {
          homeland = n;
          break;
        }
      }
      return (profile: profile, spells: records, homeland: homeland);
    });

/// Every manager of a career by name, for the news that names them (a
/// manager is named once, when he is seeded, and never renamed).
final AutoDisposeFutureProviderFamily<Map<String, int>, int>
managerIdsByNameProvider = FutureProvider.autoDispose
    .family<Map<String, int>, int>((ref, careerId) async {
      final w = await ref.read(worldManagerRepositoryProvider).load(careerId);
      return {for (final m in w.managers) m.name: m.managerId};
    });
