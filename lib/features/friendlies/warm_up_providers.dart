import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/warm_ups.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';

/// A finals tournament of this cycle that has been drawn and not yet kicked
/// off: the one a warm-up window hangs off (see [WarmUps]).
typedef WarmUpFinals = ({
  /// The World Championship, or the manager's own continental championship.
  bool worldChampionship,

  /// Its canonical stored name, for the inbox.
  String name,

  /// Its opening match day.
  DateTime opener,

  /// The drawn groups, each a list of nation ids.
  List<List<int>> groups,
});

/// The finals of [career]'s cycle still ahead of their opener, drawn: the
/// World Championship, and the manager's own confederation's championship.
/// Every other continent's championship is no business of his.
Future<List<WarmUpFinals>> upcomingWarmUpFinals(
  CompetitionRepository comp,
  Career career,
  Map<int, Nation> nations,
) async {
  final out = <WarmUpFinals>[];
  Future<void> add({
    required bool wc,
    required String name,
    required String round,
    required CompetitionKind kind,
    Confederation? confederation,
  }) async {
    if (!await comp.hasTournament(
      career.id,
      kind,
      confederation: confederation,
    )) {
      return;
    }
    final fixtures = await comp.fixturesByRound(
      career.id,
      round,
      kind: kind,
      confederation: confederation,
    );
    if (fixtures.isEmpty || fixtures.any((f) => f.hasResult)) return;
    final byGroup = <int, Set<int>>{};
    var opener = fixtures.first.date;
    for (final f in fixtures) {
      if (f.date.isBefore(opener)) opener = f.date;
      (byGroup[f.groupId ?? -1] ??= {})
        ..add(f.homeNationId)
        ..add(f.awayNationId);
    }
    final keys = byGroup.keys.toList()..sort();
    out.add((
      worldChampionship: wc,
      name: name,
      opener: opener,
      groups: [for (final k in keys) byGroup[k]!.toList()..sort()],
    ));
  }

  await add(
    wc: true,
    name: 'World Championship',
    round: 'GROUP',
    kind: CompetitionKind.worldCupFinals,
  );
  final conf = nations[career.nationId]?.confederation;
  final cup = conf == null ? null : ContinentalCups.byConfederation[conf];
  if (conf != null && cup != null) {
    await add(
      wc: false,
      name: cup.name,
      round: 'CGROUP',
      kind: CompetitionKind.continentalFinals,
      confederation: conf,
    );
  }
  return out;
}

/// Whether [nationId] is in [finals]' field.
bool inWarmUpFinals(WarmUpFinals finals, int nationId) =>
    finals.groups.any((g) => g.contains(nationId));

/// The warm-up dates before [finals] still free for a side whose fixtures
/// are [fixtures]: nothing of its own within two days either side, so no
/// side ever plays twice in three days, let alone twice on one.
List<DateTime> freeWarmUpDates(WarmUpFinals finals, List<Fixture> fixtures) => [
  for (final d in WarmUps.datesBefore(finals.opener))
    if (!fixtures.any((f) => f.date.difference(d).inDays.abs() <= 2)) d,
];

/// The warm-up dates [career]'s nation may book itself, for every finals it
/// is in (the qualified manager's window, offered through the friendlies
/// screen like any other).
Future<List<DateTime>> ownWarmUpDates(
  CompetitionRepository comp,
  Career career,
  Map<int, Nation> nations,
  List<Fixture> fixtures,
) async => [
  for (final finals in await upcomingWarmUpFinals(comp, career, nations))
    if (inWarmUpFinals(finals, career.nationId))
      ...freeWarmUpDates(finals, fixtures),
];

/// One qualified nation's invitation to a send-off friendly, made to a
/// manager whose side is not in its tournament.
typedef WarmUpOffer = ({
  /// See [WarmUps.tournamentKey].
  int tournament,

  /// The tournament's canonical stored name.
  String competition,
  int nationId,
  String nationName,

  /// The day it would be played: the first warm-up date still free.
  DateTime date,

  /// Whether the inviting side hosts it (usually: it is their send-off).
  bool theyHost,
  int cycle,
});

/// The markers an answer to an offer is stored as.
String warmUpOfferKind(int tournament, int nationId, {required bool yes}) =>
    'warmUpOffer:$tournament:$nationId:${yes ? 'yes' : 'no'}';

/// The inbox's dedup key for an offer.
String warmUpOfferMessageKey(int cycle, int tournament, int nationId) =>
    'warmUpOffer:$cycle:$tournament:$nationId';

/// Every offer [career]'s manager has to answer now, the most plausible
/// first; empty when there is none.
///
/// Only once the tournament's draw has been watched (the offers name sides in
/// it), only while his side is not in it, only while a warm-up date is free
/// and at least three days off, and only until two have been taken up.
Future<List<WarmUpOffer>> pendingWarmUpOffers(
  CompetitionRepository comp,
  Career career,
  Map<int, Nation> nations,
) async {
  final me = nations[career.nationId];
  if (me == null) return const [];
  final cycle = career.cyclePointer;
  final mine = await comp.fixturesForNation(career.id, career.nationId);
  final out = <WarmUpOffer>[];
  for (final finals in await upcomingWarmUpFinals(comp, career, nations)) {
    if (inWarmUpFinals(finals, career.nationId)) continue;
    final drawKind = finals.worldChampionship
        ? worldCupDrawKind
        : continentalFinalsDrawKind;
    if (!await comp.hasWatchedDraw(career.id, cycle, drawKind)) continue;
    final free = freeWarmUpDates(finals, mine);
    if (free.isEmpty) continue;
    final date = free.first;
    final last = DateTime(date.year, date.month, date.day - 3);
    if (!career.inGameDate.isBefore(last)) continue;
    final tournament = WarmUps.tournamentKey(
      worldChampionship: finals.worldChampionship,
    );
    final offers = WarmUps.offers(
      seed: career.rngSeed,
      cycle: cycle,
      tournament: tournament,
      me: me,
      nations: nations,
      groups: finals.groups,
    );
    var accepted = 0;
    final open = <int>[];
    for (final id in offers) {
      if (await comp.hasWatchedDraw(
        career.id,
        cycle,
        warmUpOfferKind(tournament, id, yes: true),
      )) {
        accepted++;
      } else if (!await comp.hasWatchedDraw(
        career.id,
        cycle,
        warmUpOfferKind(tournament, id, yes: false),
      )) {
        open.add(id);
      }
    }
    if (accepted >= WarmUps.maxAccepted) continue;
    for (final id in open) {
      out.add((
        tournament: tournament,
        competition: finals.name,
        nationId: id,
        nationName: nations[id]?.name ?? '',
        date: date,
        theyHost: WarmUps.offererHosts(
          seed: career.rngSeed,
          cycle: cycle,
          tournament: tournament,
          offerer: id,
        ),
        cycle: cycle,
      ));
    }
  }
  return out;
}

/// The offer the hub puts in front of the manager now, or null.
final AutoDisposeFutureProviderFamily<WarmUpOffer?, int>
pendingWarmUpOfferProvider = FutureProvider.autoDispose
    .family<WarmUpOffer?, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final nations = {
        for (final n
            in await ref.watch(nationRepositoryProvider).forCareer(careerId))
          n.id: n,
      };
      final offers = await pendingWarmUpOffers(
        ref.watch(competitionRepositoryProvider),
        career,
        nations,
      );
      return offers.firstOrNull;
    });

/// Answers the warm-up offers, and files them in the inbox.
class WarmUpOfferService {
  WarmUpOfferService(this._ref);

  final Ref _ref;

  /// Takes [offer] up: the friendly is booked on its date, at the inviting
  /// side's ground unless they come to him, as an ordinary friendly with a
  /// window (and a call-up) of its own.
  Future<void> accept(int careerId, WarmUpOffer offer) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    // Booked on the date still free NOW, not the one the screen was opened
    // with: two acceptances in a row take the two dates in turn.
    final current = (await _pending(career)).where(
      (o) => o.tournament == offer.tournament && o.nationId == offer.nationId,
    );
    final live = current.firstOrNull;
    if (live != null) {
      await comp.saveFriendlies(
        careerId: careerId,
        nationId: career.nationId,
        cycle: career.cyclePointer,
        friendlies: [
          (date: live.date, opponentId: live.nationId, home: !live.theyHost),
        ],
      );
    }
    await comp.markDrawWatched(
      careerId,
      offer.cycle,
      warmUpOfferKind(offer.tournament, offer.nationId, yes: live != null),
    );
    _invalidate(careerId);
  }

  /// Turns [offer] down. Nothing is booked.
  Future<void> decline(int careerId, WarmUpOffer offer) async {
    await _ref
        .read(competitionRepositoryProvider)
        .markDrawWatched(
          careerId,
          offer.cycle,
          warmUpOfferKind(offer.tournament, offer.nationId, yes: false),
        );
    _invalidate(careerId);
  }

  /// Files every open offer in the inbox, once each. Run after each step of
  /// the world and when the offer screen opens, so an offer made while the
  /// manager watched a draw is in the inbox by the time he answers it.
  Future<void> fileMessages(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final comp = _ref.read(competitionRepositoryProvider);
    final keys = await comp.messageKeys(careerId);
    var filed = false;
    for (final o in await _pending(career)) {
      final key = warmUpOfferMessageKey(o.cycle, o.tournament, o.nationId);
      if (keys.contains(key)) continue;
      await comp.addTextMessage(
        l: _ref.read(appLocalizationsProvider),
        careerId: careerId,
        dedupKey: key,
        category: 'friendly',
        title: MsgText(MsgKey.warmUpOfferMsgTitle, [o.nationName]),
        body: MsgText(MsgKey.warmUpOfferMsgBody, [
          o.nationName,
          MsgComp(o.competition),
        ]),
        year: career.inGameDate.year,
      );
      filed = true;
    }
    if (filed) {
      _ref
        ..invalidate(messageInboxProvider(careerId))
        ..invalidate(unreadMessagesProvider(careerId));
    }
  }

  Future<List<WarmUpOffer>> _pending(Career career) async {
    final nations = {
      for (final n
          in await _ref.read(nationRepositoryProvider).forCareer(career.id))
        n.id: n,
    };
    return pendingWarmUpOffers(
      _ref.read(competitionRepositoryProvider),
      career,
      nations,
    );
  }

  void _invalidate(int careerId) => _ref
    ..invalidate(pendingWarmUpOfferProvider(careerId))
    ..invalidate(nextEventProvider(careerId))
    ..invalidate(hubDataProvider(careerId));
}

final Provider<WarmUpOfferService> warmUpOfferServiceProvider = Provider(
  WarmUpOfferService.new,
);
