import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/entities/world_manager.dart';

/// Which manager moves reach the player's inbox, and what they say.
///
/// A decision point that makes [summaryMin] or more changes files ONE
/// summary of all of them (the paged "Manager changes" report, see
/// [summaryDedupKey]), and a message of its own only for a change that is
/// personal: a manager he has a tie with, or one of his nations (now or
/// before), which covers his own job and a man poached from him
/// ([personalRank]). A point with a single change keeps the older rule:
/// news when it touches the player (those two, a side he is about to play,
/// or the top 10 of his confederation). At most [maxPerPass] messages of
/// their own per decision point.
abstract final class ManagerNews {
  /// How many changes at one decision point make a summary.
  static const int summaryMin = 2;

  /// The highest [newsworthy] rank still worth a message of its own beside
  /// a summary: 0 a tied manager, 1 the player's own nations.
  static const int personalRank = 1;

  /// The dedup key of the summary of the decision point [key].
  static String summaryDedupKey(String key) => 'mgr:$key:all';

  /// The moves of [moves] a summary lists: those that name somebody.
  static List<ManagerMove> named(List<ManagerMove> moves) => [
    for (final m in moves)
      if (m.outgoingId != null || m.incomingId != null) m,
  ];

  /// The most news one decision point files.
  static const int maxPerPass = 3;

  /// The inbox category of manager news.
  static const String category = 'manager';

  /// The dedup key of the news about [nationId] at the decision point [key].
  static String dedupKey(String key, int nationId) => 'mgr:$key:$nationId';

  /// The moves of [moves] worth news, at most [maxPerPass], ranked: a tied
  /// manager first, then the player's nations, then his upcoming opponents,
  /// then his confederation's top 10. Within a rank, the order of [moves].
  /// [maxRank] drops every rank past it (see [personalRank]).
  static List<ManagerMove> newsworthy(
    List<ManagerMove> moves, {
    required Set<int> tiedManagerIds,
    required Set<int> myNations,
    required Set<int> upcomingOpponents,
    required Set<int> confTop10,
    int maxRank = 3,
  }) {
    int? rankOf(ManagerMove m) {
      // A move with nobody to name says nothing.
      if (m.outgoingId == null && m.incomingId == null) return null;
      if (tiedManagerIds.contains(m.outgoingId) ||
          tiedManagerIds.contains(m.incomingId)) {
        return 0;
      }
      if (myNations.contains(m.nationId)) return 1;
      if (upcomingOpponents.contains(m.nationId)) return 2;
      if (confTop10.contains(m.nationId)) return 3;
      return null;
    }

    final ranked =
        <({int rank, int order, ManagerMove move})>[
          for (var i = 0; i < moves.length; i++)
            if (rankOf(moves[i]) case final r? when r <= maxRank)
              (rank: r, order: i, move: moves[i]),
        ]..sort((a, b) {
          final c = a.rank.compareTo(b.rank);
          return c != 0 ? c : a.order.compareTo(b.order);
        });
    return [for (final r in ranked.take(maxPerPass)) r.move];
  }

  /// The message about [m], as meaning: [nation] is the nation's name,
  /// [outgoing] and [incoming] the names of the men leaving and arriving
  /// (names are never translated). The title says who left and why, or who
  /// was appointed when nobody left; the body names the new man, and is
  /// null when nobody has been appointed yet. Null when the move names
  /// nobody it can say: no one left and no one came in.
  static ({MsgPart title, MsgPart? body})? message(
    ManagerMove m, {
    required String nation,
    required String? outgoing,
    required String? incoming,
  }) {
    final body = incoming == null
        ? null
        : MsgText(MsgKey.mgrNewsAppointedBody, [nation, incoming]);
    final why = m.why;
    if (outgoing == null || why == null) {
      if (incoming == null) return null;
      return (
        title: MsgText(MsgKey.mgrNewsAppointed, [nation, incoming]),
        body: body,
      );
    }
    final key = switch (why) {
      SpellEnd.sacked => MsgKey.mgrNewsSacked,
      SpellEnd.resigned => MsgKey.mgrNewsResigned,
      SpellEnd.poached => MsgKey.mgrNewsPoached,
      SpellEnd.retired => MsgKey.mgrNewsRetired,
      SpellEnd.contractEnd => MsgKey.mgrNewsContractEnd,
      SpellEnd.replacedByPlayer => MsgKey.mgrNewsReplacedByPlayer,
    };
    return (title: MsgText(key, [nation, outgoing]), body: body);
  }

  /// The managers a stored news [spec] names, in the order it names them
  /// (the man who left, then the man appointed), each once. Every string
  /// [message] writes is `[nation, name]`; anything else names nobody.
  static List<String> namesIn(MessageSpec spec) {
    final names = <String>[];
    for (final part in [spec.title, spec.body]) {
      if (part is! MsgText || part.args.length < 2) continue;
      if (!_newsKeys.contains(part.key)) continue;
      final name = part.args[1];
      if (name is String && name.isNotEmpty && !names.contains(name)) {
        names.add(name);
      }
    }
    return names;
  }

  static const Set<MsgKey> _newsKeys = {
    MsgKey.mgrNewsSacked,
    MsgKey.mgrNewsResigned,
    MsgKey.mgrNewsPoached,
    MsgKey.mgrNewsRetired,
    MsgKey.mgrNewsContractEnd,
    MsgKey.mgrNewsReplacedByPlayer,
    MsgKey.mgrNewsAppointed,
    MsgKey.mgrNewsAppointedBody,
  };
}
