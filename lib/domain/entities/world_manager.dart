/// Where a world manager came from.
enum ManagerOrigin { fresh, exPlayer, exAssistant }

/// Why a spell in charge of a nation ended.
enum SpellEnd {
  sacked,
  resigned,
  poached,
  retired,
  contractEnd,
  replacedByPlayer,
}

/// What a tie between a manager and the world is about.
enum TieKind {
  grudge,
  successor,
  protege,
  formerPlayer,
  pressDig,
  pressRespect,
}

/// One manager of the world: stored once, never renamed.
class WorldManager {
  const WorldManager({
    required this.managerId,
    required this.name,
    required this.nationality,
    required this.birthYear,
    required this.style,
    required this.origin,
    required this.enteredAt,
    this.retiredAt,
    this.sourceId,
  });

  final int managerId;
  final String name;

  /// FIFA code, upper case.
  final String nationality;
  final int birthYear;

  /// A `NationStyle` name.
  final String style;
  final ManagerOrigin origin;
  final DateTime enteredAt;
  final DateTime? retiredAt;
  final int? sourceId;

  WorldManager copyWith({DateTime? retiredAt}) => WorldManager(
    managerId: managerId,
    name: name,
    nationality: nationality,
    birthYear: birthYear,
    style: style,
    origin: origin,
    enteredAt: enteredAt,
    retiredAt: retiredAt ?? this.retiredAt,
    sourceId: sourceId,
  );
}

/// One manager's time in charge of one nation.
class ManagerSpell {
  const ManagerSpell({
    required this.spellNo,
    required this.managerId,
    required this.nationId,
    required this.fromDate,
    required this.contractUntil,
    this.toDate,
    this.endReason,
    this.briefNet = 0,
  });

  final int spellNo;
  final int managerId;
  final int nationId;
  final DateTime fromDate;
  final DateTime? toDate;
  final SpellEnd? endReason;
  final DateTime contractUntil;
  final int briefNet;

  bool get current => toDate == null;

  /// The same spell, ended on [on] for [why].
  ManagerSpell close(DateTime on, SpellEnd why) => ManagerSpell(
    spellNo: spellNo,
    managerId: managerId,
    nationId: nationId,
    fromDate: fromDate,
    toDate: on,
    endReason: why,
    contractUntil: contractUntil,
    briefNet: briefNet,
  );
}

/// A tie a manager formed; one row per event that moved it.
class ManagerTie {
  const ManagerTie({
    required this.tieNo,
    required this.managerId,
    required this.kind,
    required this.delta,
    required this.date,
  });

  final int tieNo;
  final int managerId;
  final TieKind kind;
  final int delta;
  final DateTime date;
}

/// A change of manager at a nation, in memory only.
typedef ManagerMove = ({
  int nationId,
  int? outgoingId,
  SpellEnd? why,
  int? incomingId,
  DateTime date,
});

/// Every manager and spell of one career.
class ManagerWorld {
  const ManagerWorld({required this.managers, required this.spells});

  final List<WorldManager> managers;
  final List<ManagerSpell> spells;

  /// The nation's open spell, if any.
  ManagerSpell? currentAt(int nationId) {
    for (final s in spells) {
      if (s.nationId == nationId && s.current) return s;
    }
    return null;
  }

  /// The latest-starting spell at [nationId] covering [d].
  ManagerSpell? inChargeOn(int nationId, DateTime d) {
    ManagerSpell? best;
    for (final s in spells) {
      if (s.nationId != nationId || s.fromDate.isAfter(d)) continue;
      final to = s.toDate;
      if (to != null && !d.isBefore(to)) continue;
      if (best == null ||
          s.fromDate.isAfter(best.fromDate) ||
          (s.fromDate == best.fromDate && s.spellNo > best.spellNo)) {
        best = s;
      }
    }
    return best;
  }

  /// Managers with no current spell who have not retired.
  List<WorldManager> free(DateTime d) {
    final busy = {
      for (final s in spells)
        if (s.current) s.managerId,
    };
    return [
      for (final m in managers)
        if (!busy.contains(m.managerId) && m.retiredAt == null) m,
    ];
  }

  int get nextManagerId =>
      managers.fold(0, (a, m) => m.managerId > a ? m.managerId : a) + 1;

  int get nextSpellNo =>
      spells.fold(0, (a, s) => s.spellNo > a ? s.spellNo : a) + 1;
}

/// One step's worth of changes to the managers of a career.
class ManagerChanges {
  const ManagerChanges({
    this.added = const [],
    this.updated = const [],
    this.opened = const [],
    this.closed = const [],
    this.renewed = const [],
    this.ties = const [],
    this.moves = const [],
  });

  final List<WorldManager> added;
  final List<WorldManager> updated;
  final List<ManagerSpell> opened;
  final List<ManagerSpell> closed;
  final List<ManagerSpell> renewed;
  final List<ManagerTie> ties;

  /// Never persisted.
  final List<ManagerMove> moves;

  bool get isEmpty =>
      added.isEmpty &&
      updated.isEmpty &&
      opened.isEmpty &&
      closed.isEmpty &&
      renewed.isEmpty &&
      ties.isEmpty &&
      moves.isEmpty;
}
