import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/assistant_advice.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

/// The assistant's pre-match proposal for the side as it stands, and what he
/// read of the opponent (null when he did not, or could not, read one).
typedef LineupAdviceRead = ({
  StaffTier tier,
  PreMatchAdvice? advice,
  bool? opponentStronger,
});

/// The assistant's read of the next eleven, derived (never stored) from the
/// tactic, the squad who can play, their condition and, for an elite man,
/// the next opponent.
///
/// The "Ask the assistant" button reads it on the tap and lets it go, so the
/// answer is worked out from the squad as it stands at that moment and
/// nothing is computed for a manager who never asks.
///
/// Deterministic: the assistant's rough eye is seeded on the save and the
/// in-game date, so asking twice on the same day gives the same answer and
/// the answer moves on with the calendar.
final AutoDisposeFutureProviderFamily<LineupAdviceRead?, int>
lineupAdviceProvider = FutureProvider.autoDispose
    .family<LineupAdviceRead?, int>((ref, careerId) async {
      // Every input is watched BEFORE the first await. Watching an
      // auto-disposed provider's future after a gap lets it be torn down in
      // between and leaves riverpod 2.6 a completer it later completes twice.
      // The button only watches this once somebody is in the job, so nobody
      // pays for the condition read on a save without an assistant.
      final careerF = ref.watch(careerByIdProvider(careerId).future);
      final dataF = ref.watch(tacticDataProvider(careerId).future);
      final conditionF = ref.watch(squadConditionProvider(careerId).future);
      final hubF = ref.watch(hubDataProvider(careerId).future);

      final career = await careerF;
      if (career == null) return null;
      final tier = career.staffAssistant;
      if (tier == StaffTier.none) {
        return (tier: tier, advice: null, opponentStronger: null);
      }
      final data = await dataF;
      if (data == null) return null;

      // Only the men who actually read condition use it.
      var condition = const <int, PlayerCondition>{};
      if (tier != StaffTier.basic) {
        try {
          condition = await conditionF;
        } on Object {
          // Advice without the condition read is still advice.
        }
      }

      // The elite man reads the opponent, once his draw has been watched
      // (the briefing keeps the opponent back until then, and so does he).
      bool? opponentStronger;
      if (tier == StaffTier.elite) {
        final hub = await hubF;
        final next = hub?.next;
        if (hub != null && next != null && hub.nextDrawWatched) {
          final me = career.nationId;
          final opp = next.homeNationId == me
              ? next.awayNationId
              : next.homeNationId;
          final mine = hub.nations[me]?.ranking;
          final theirs = hub.nations[opp]?.ranking;
          if (mine != null && theirs != null && mine != theirs) {
            opponentStronger = theirs < mine;
          }
        }
      }

      final day = career.inGameDate.difference(DateTime.utc(2000)).inDays;
      final advice = AssistantAdvice.lineup(
        tier: tier,
        places: data.tactic.positions,
        pool: data.pool,
        seed: career.rngSeed ^ (day * 0x9E3779B1),
        condition: condition,
        unavailableIds: {for (final p in data.unavailable) p.id},
        opponentStronger: opponentStronger,
      );
      return (tier: tier, advice: advice, opponentStronger: opponentStronger);
    });
