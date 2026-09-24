import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/domain/services/tactics/set_piece_picks.dart';
import 'package:fnm/domain/services/tactics/substitution_rules.dart';
import 'package:fnm/features/tactics/formation_picker.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The tactical setup a manager confirms from the in-match editor: the shape,
/// the on-pitch XI (slot → player id, in [formation]'s order) and instructions,
/// to take effect from the current minute onward.
class InMatchTacticsResult {
  const InMatchTacticsResult({
    required this.formation,
    required this.lineup,
    required this.instructions,
    required this.takers,
  });

  final Formation formation;
  final List<int?> lineup;
  final TacticalInstructions instructions;

  /// Who takes penalties and dead balls from here on. Either may be null,
  /// which hands that duty back to the engine's own pick.
  final ({int? penalty, int? deadBall}) takers;
}

/// Opens the full in-match tactics editor (shape, XI, subs and instructions) as
/// a page and returns the confirmed setup, or null if the manager backed out.
Future<InMatchTacticsResult?> showInMatchTactics(
  BuildContext context, {
  required int minute,
  required Formation formation,
  required List<int?> lineup,
  required TacticalInstructions instructions,
  required List<Player> pool,
  required Set<int> startingIds,
  required int maxSubs,
  ({int? penalty, int? deadBall}) takers = (penalty: null, deadBall: null),
  Set<int> injuredIds = const {},
  Set<int> sentOffIds = const {},
  Map<int, int> energyByPlayer = const {},
  Map<int, int> cameOnAt = const {},
  Map<int, int> wentOffAt = const {},
  List<Color>? teamColors,
}) {
  return Navigator.of(context).push<InMatchTacticsResult>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _InMatchTacticsEditor(
        minute: minute,
        formation: formation,
        lineup: lineup,
        instructions: instructions,
        pool: pool,
        startingIds: startingIds,
        maxSubs: maxSubs,
        takers: takers,
        injuredIds: injuredIds,
        sentOffIds: sentOffIds,
        energyByPlayer: energyByPlayer,
        cameOnAt: cameOnAt,
        wentOffAt: wentOffAt,
        teamColors: teamColors,
      ),
    ),
  );
}

class _InMatchTacticsEditor extends StatefulWidget {
  const _InMatchTacticsEditor({
    required this.minute,
    required this.formation,
    required this.lineup,
    required this.instructions,
    required this.pool,
    required this.startingIds,
    required this.maxSubs,
    required this.takers,
    this.injuredIds = const {},
    this.sentOffIds = const {},
    this.energyByPlayer = const {},
    this.cameOnAt = const {},
    this.wentOffAt = const {},
    this.teamColors,
  });

  final int minute;
  final Formation formation;
  final List<int?> lineup;
  final TacticalInstructions instructions;
  final List<Player> pool;
  final Set<int> startingIds;
  final int maxSubs;

  /// The side's set-piece takers as the editor opens.
  final ({int? penalty, int? deadBall}) takers;

  /// Live remaining energy (0–100) per player id, shown on the pitch and bench
  /// so the manager can see who's tiring before making a sub.
  final Map<int, int> energyByPlayer;

  /// Players hurt this match and not yet replaced — flagged orange on the pitch
  /// so the manager knows exactly who to take off.
  final Set<int> injuredIds;

  /// Players sent off this match. They are gone for good: off the pitch, off
  /// the bench, and NOT replaceable — the side simply plays a man down. They
  /// used to sit in the squad list unmarked and could be subbed on again.
  final Set<int> sentOffIds;

  /// The minute each man already on the pitch came on, for those who were not
  /// in the starting eleven, and the minute each man already taken off went
  /// off. Both are read off the changes the manager has made earlier in this
  /// match; a player missing from either simply has his minute left unsaid.
  ///
  /// Only the caller can know them. This sheet sees one moment of the match,
  /// so on its own it could say no more than "he is not a starter", which is
  /// the half of the answer the manager already had.
  final Map<int, int> cameOnAt;
  final Map<int, int> wentOffAt;

  /// The manager's kit colours, filling the player discs on the pitch.
  final List<Color>? teamColors;

  @override
  State<_InMatchTacticsEditor> createState() => _InMatchTacticsEditorState();
}

class _InMatchTacticsEditorState extends State<_InMatchTacticsEditor> {
  late Formation _formation = widget.formation;

  /// The XI with any sent-off player's slot vacated — the shape the manager is
  /// actually working with once someone has walked.
  late List<int?> _lineup = [
    for (final id in widget.lineup)
      if (id != null && widget.sentOffIds.contains(id)) null else id,
  ];
  late TacticalInstructions _instructions = widget.instructions;
  late ({int? penalty, int? deadBall}) _takers = widget.takers;

  /// Everyone still eligible to be on the pitch: the squad minus the sent off.
  late final List<Player> _eligible = widget.pool
      .where((p) => !widget.sentOffIds.contains(p.id))
      .toList();

  late final Map<int, Player> _byId = {for (final p in widget.pool) p.id: p};

  /// Who was on the pitch when this sheet opened.
  ///
  /// Pinned at open so a minute can be told apart from a missing one: a change
  /// made HERE happened at [_InMatchTacticsEditor.minute] and can say so,
  /// while a change made earlier in the match happened at a minute only the
  /// caller knows.
  ///
  /// The mirror of this, who had ALREADY been taken off, went with the spent
  /// pile: nothing prints a withdrawal minute any more, because nothing prints
  /// the withdrawn.
  late final Set<int> _onPitchAtOpen = widget.lineup.whereType<int>().toSet();

  /// The man the manager has tapped to come off, while he chooses who replaces
  /// him. Tapping him again puts the idea back.
  ///
  /// Drag-and-drop was the only way to make a change, and it is the least
  /// discoverable gesture on a phone: "drag mi nefunguje" was reported as a
  /// broken feature. Tapping is the addition; the drag is untouched.
  int? _comingOff;

  /// The slots a sending-off has taken out of the shape — see [deadSlots].
  /// Derived, never remembered, so a change of formation moves the hole with
  /// the rest of the side instead of leaving it pointing at somebody.
  Set<int> get _dead =>
      deadSlots(lineup: _lineup, sentOffCount: widget.sentOffIds.length);

  /// The man the manager is taking off, if he is still on the pitch. A change
  /// (or an undo) may have moved him since he was tapped.
  Player? get _comingOffPlayer {
    final id = _comingOff;
    if (id == null || !_onPitch.contains(id)) return null;
    return _byId[id];
  }

  /// Refuses a change the rules do not allow, saying which rule refused it.
  void _refuse(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Ids currently on the pitch.
  Set<int> get _onPitch => _lineup.whereType<int>().toSet();

  /// The eleven actually on the pitch, for the side's live overall.
  List<Player> get _onPitchPlayers => [
    for (final id in _lineup)
      if (id != null && _byId[id] != null) _byId[id]!,
  ];

  /// The designated takers with anyone no longer on the pitch dropped.
  ///
  /// A named taker who has been substituted or sent off is ignored by the
  /// engine anyway, so the slot falls back to automatic rather than to nobody:
  /// null already means "let the engine pick", and a second state for "he has
  /// gone" would only be the same thing under another name.
  ({int? penalty, int? deadBall}) get _liveTakers {
    final on = _onPitch;
    return (
      penalty: on.contains(_takers.penalty) ? _takers.penalty : null,
      deadBall: on.contains(_takers.deadBall) ? _takers.deadBall : null,
    );
  }

  /// A sub is spent for every starter no longer on the pitch (chains of
  /// replacements still count as a single change to that starter's slot). A
  /// sending-off is not a substitution — it costs a player, not a change.
  int get _subsUsed => widget.startingIds
      .where((id) => !_onPitch.contains(id) && !widget.sentOffIds.contains(id))
      .length;

  bool get _overLimit => _subsUsed > widget.maxSubs;

  /// Starters already taken off. They cannot come back on: football has no
  /// re-entry. Seeded from the XI the sheet opened with, so a manager reopening
  /// the editor later in the match still cannot undo an earlier change.
  ///
  /// A man sent off is NOT in here. He is off the pitch and he is a starter,
  /// so he fell into this set by arithmetic — and since the rules ask about
  /// withdrawal before they ask about a red card, the squad list told the
  /// manager he had "already been taken off". He was not taken off; he was
  /// sent off, which is a different thing with a different consequence.
  /// Which half of the squad the sheet is showing.
  ///
  /// Opens on the candidates: the manager came here to change something, and
  /// who is already playing is visible on the pitch above either way.
  _SquadTab _tab = _SquadTab.candidates;

  late Set<int> _withdrawn = widget.startingIds
      .where(
        (id) => !_onPitch.contains(id) && !widget.sentOffIds.contains(id),
      )
      .toSet();

  /// The states the XI has passed through in THIS sheet, newest last, so a
  /// misclick can be taken back. A manager who put the wrong man on had to
  /// leave the editor and lose every other change with him.
  ///
  /// Only what this sheet did is on here: the oldest entry is the XI the sheet
  /// opened with, so a substitution made ten minutes ago — part of the match,
  /// not of this sheet — can never be popped off, and football's ban on
  /// re-entry survives the undo intact.
  ///
  /// The withdrawn set travels alongside the lineup because it is not purely
  /// derived: a substitute who came on earlier in this sheet and was then
  /// taken off again belongs in it, and no formula over the starting XI
  /// would find him. The substitution COUNT needs no such help — [_subsUsed]
  /// reads the lineup, so restoring the lineup restores the count.
  final List<({List<int?> lineup, Set<int> withdrawn})> _undo = [];

  /// Remembers the XI as it stands, just before it is changed.
  void _pushUndo() =>
      _undo.add((lineup: [..._lineup], withdrawn: {..._withdrawn}));

  /// Takes back the last change made in this sheet.
  void _undoLast() {
    if (_undo.isEmpty) return;
    setState(() {
      final previous = _undo.removeLast();
      _lineup = previous.lineup;
      _withdrawn = previous.withdrawn;
      // Not snapshotted, because it is not part of the XI: it is a half-made
      // gesture, and the half-made gesture the manager has just undone is
      // certainly not the one he still means.
      _comingOff = null;
    });
  }

  void _setFormation(Formation f) {
    if (f == _formation) return;
    // Refits the players who are ALREADY ON THE PITCH to the new shape, and
    // nobody else.
    //
    // It used to top the pool up from the bench whenever fewer than eleven
    // were out there, which is precisely the situation after a sending-off:
    // changing shape with ten men silently brought a substitute on, spending
    // no substitution, and the red card was undone by dragging a player
    // sideways. A reshape rearranges who is on the pitch. Putting somebody new
    // on is a substitution, and has to cost one.
    setState(() {
      _formation = f;
      _comingOff = null;
      // Short by however many have walked: bestEleven leaves those slots null.
      _lineup = bestEleven(f, reshapePool(_eligible, _onPitch));
      // A reshape re-derives the whole XI against a different set of slots, so
      // the lineups remembered under the old shape no longer mean anything:
      // restoring one would put players in positions they were never picked
      // for. The history starts again from the new shape.
      _undo.clear();
    });
  }

  void _swap(int a, int b) {
    if (a == b) return;
    // Moving sideways into the hole a red card left would put eleven men back
    // on the pitch in all but name — the side would simply be playing a
    // different shape with a full complement. The place is gone, not vacant.
    if (_dead.contains(a) || _dead.contains(b)) {
      _refuse(AppLocalizations.of(context).tacticsSlotLostToRedCard);
      return;
    }
    setState(() {
      _pushUndo();
      _comingOff = null;
      final l = [..._lineup];
      final tmp = l[a];
      l[a] = l[b];
      l[b] = tmp;
      _lineup = l;
    });
  }

  /// Puts [playerId] into [slot], swapping if they already start elsewhere (so
  /// the displaced player moves rather than duplicating), or otherwise pushing
  /// the previous occupant off the pitch (a substitution).
  ///
  /// The change is refused outright when it would break the substitution
  /// rules — the snackbar on [_apply] used to be the only thing standing in
  /// the way, which let the board reach a state football does not allow.
  void _setSlot(int slot, int playerId) {
    // The place a sending-off took is refused before anything is asked about
    // the player: it is not that this man may not come on, it is that nobody
    // may. The slot was merely VACATED before, and an empty slot reads as
    // "put somebody here" — so the bench filled it, no substitution was spent,
    // and the side carried on with eleven.
    if (_dead.contains(slot)) {
      _refuse(AppLocalizations.of(context).tacticsSlotLostToRedCard);
      return;
    }
    final refusal = refusalToBringOn(
      startingIds: widget.startingIds,
      onPitch: _onPitch,
      sentOffIds: widget.sentOffIds,
      withdrawnIds: _withdrawn,
      maxSubs: widget.maxSubs,
      playerId: playerId,
    );
    if (refusal != SubRefusal.none) {
      final l = AppLocalizations.of(context);
      // Say WHICH rule stopped him. Every refusal used to be reported as the
      // sub count being spent, so a manager dragging a man he had already
      // taken off was told he had made too many changes.
      final who = _byId[playerId]?.name ?? '';
      final message = switch (refusal) {
        SubRefusal.alreadyWithdrawn => l.tacticsSubAlreadyOff(who),
        SubRefusal.sentOff => l.tacticsSubSentOff(who),
        SubRefusal.noSubsLeft ||
        SubRefusal.none => l.tacticsTooManySubs(widget.maxSubs),
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }
    setState(() {
      _pushUndo();
      _comingOff = null;
      final l = [..._lineup];
      final existing = l.indexOf(playerId);
      if (existing != -1) {
        l[existing] = l[slot];
      } else if (l[slot] case final out?) {
        _withdrawn = {..._withdrawn, out};
      }
      l[slot] = playerId;
      _lineup = l;
    });
  }

  void _apply() {
    if (_overLimit) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.tacticsTooManySubs(widget.maxSubs),
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      InMatchTacticsResult(
        formation: _formation,
        lineup: _lineup,
        instructions: _instructions,
        takers: _liveTakers,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final onPitch = _onPitch;
    // Everyone NOT on the pitch, sent off included. The sent off were left out
    // of this list because they are not substitutes, which is true and which
    // is also why the list could not answer the question the manager was
    // actually asking it: who have I already used.
    final offPitch = widget.pool.where((p) => !onPitch.contains(p.id)).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    final available = [
      for (final p in offPitch)
        if (!_standing(p).blocked) p,
    ];
    // With a man picked to come off, AVAILABLE answers a narrower question:
    // who can take HIS place. A goalkeeping slot is keeper-only and every
    // other slot is outfield-only — the same rule the slot picker has always
    // applied — and what is left is ordered by who suits the position rather
    // than by who is best in the abstract.
    final coming = _comingOffPlayer;
    if (coming != null) {
      final slot = _lineup.indexOf(coming.id);
      if (slot != -1) {
        final position = _formation.positions[slot];
        final keeperSlot = position.category == PositionCategory.goalkeeper;
        available
          ..removeWhere(
            (p) =>
                (p.position.category == PositionCategory.goalkeeper) !=
                keeperSlot,
          )
          ..sort(PositionFit.bySlotFit(position));
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // The minute, and under it the side's overall as it stands — the same
        // number the pre-match screen shows either side of the "VS". It moves
        // with every change made here, which is the point: a manager taking a
        // tired star off should see what it costs him.
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.tacticsMinuteTitle(widget.minute),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              '${l.teamOverall} ${squadOverall(_onPitchPlayers)}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _apply,
            child: Text(
              l.tacticsApply,
              style: AppTypography.labelMedium.copyWith(
                color: _overLimit ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: l.tacticsTabLineupSubs),
                Tab(text: l.tacticsTabTactics),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _lineupTab(
                    onPitch: _onPitchPlayers,
                    available: available,
                    comingOff: coming,
                  ),
                  _tacticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The pitch, and under it the three lists the manager actually reads.
  ///
  /// It used to be ONE list: everybody not on the pitch, best first, with the
  /// men who could not come on greyed out among the ones who could. The
  /// manager's words were "celkovo to nabizeni hracov na striedanie mi prislo
  /// celkom neprehladne. vlastne z toho neviem kto hra od zaciatku" — it
  /// offers everyone, and it never says who is playing. Who was on the pitch
  /// appeared nowhere but as eleven discs above, and a greyed row sitting
  /// between two live ones reads as part of the same offer.
  ///
  /// So the same men are dealt into three named piles, in the order the
  /// questions get asked: who is out there, who can I bring on, and who have I
  /// already used. The third is always drawn, never folded away — answering
  /// that last question is the whole reason it exists.
  Widget _lineupTab({
    required List<Player> onPitch,
    required List<Player> available,
    required Player? comingOff,
  }) {
    final l = AppLocalizations.of(context);
    return ListView(
      children: [
        // The formation picker lives on the Tactics tab and nowhere else. It
        // used to be repeated here, above the pitch, so the same row of shape
        // chips appeared twice in one sheet — two controls for one setting,
        // which reads as a bug whichever one you touch.
        AspectRatio(
          aspectRatio: 3 / 4,
          child: TacticsPitch(
            formation: _formation,
            instructions: _instructions,
            lineup: _lineup,
            byId: _byId,
            teamColors: widget.teamColors,
            energyByPlayer: widget.energyByPlayer,
            // Mark the hurt players absent AND injured so their node renders the
            // orange "INJURED — REPLACE" flag, exactly like a pre-match injury.
            absentIds: widget.injuredIds,
            injuredIds: widget.injuredIds,
            // The holes a red card left, drawn as holes rather than as spaces
            // waiting to be filled.
            deadSlots: _dead,
            onTapSlot: _pickPlayer,
            onSwap: (a, b) {
              switch (resolveDrag(_formation, a, b)) {
                case SwapSlots():
                  _swap(a, b);
                case ReshapeTo(:final formation):
                  _reshapeKeeping(formation, a, b);
              }
            },
            onBenchIn: _setSlot,
            onMoveToSpace: (slot, dropY) {
              final outcome = resolveSpaceDrag(
                _formation,
                _instructions,
                slot,
                dropY,
              );
              // Through _setFormation, which refits the players already on the
              // pitch — assigning _formation directly would scramble the side
              // mid-match.
              if (outcome case ReshapeTo(:final formation)) {
                _setFormation(formation);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Both gestures are named, tap first. The drag was the only one
              // there was, and it is the least discoverable thing on a phone.
              Text(
                comingOff == null
                    ? l.tacticsDragSubOn
                    : l.tacticsPickReplacementFor(comingOff.name),
                style: AppTypography.labelSmall.copyWith(
                  color: comingOff == null
                      ? AppColors.onSurfaceVariant
                      : AppColors.primary,
                ),
              ),
              // Only while there is something to take back, and only ever what
              // THIS sheet changed. A misclicked substitution used to be final
              // the moment it landed: the one way out was to leave the editor,
              // which threw away every other change made with it.
              if (_undo.isNotEmpty)
                InkWell(
                  onTap: _undoLast,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.undo_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            l.tacticsUndoLastChange,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Say plainly that the side is short. The pitch says it too now,
              // on the barred spot itself, but this is the line that names the
              // man it happened to.
              if (widget.sentOffIds.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.block_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l.tacticsSentOffNote(
                          widget.sentOffIds
                              .map((id) => _byId[id]?.name)
                              .whereType<String>()
                              .join(', '),
                        ),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              // TWO TABS, not three stacked sections.
              //
              // Stacked, the pitch and three lists made one long scroll and a
              // manager reported losing part of it off the bottom. Two tabs
              // are two short lists, and the sheet stops being a column you
              // have to remember your place in.
              //
              // The spent pile is GONE rather than moved into a tab. It was
              // there to answer "who have I already used" and the manager
              // decided he does not need the answer badly enough to pay a
              // third list for it; a withdrawn man simply leaves the sheet.
              _SquadTabs(
                onPitch: _tab == _SquadTab.onPitch,
                onPitchLabel: l.tacticsSectionOnPitch(
                  onPitch.length,
                  _lineup.length,
                ),
                candidatesLabel: l.tacticsSectionAvailable(available.length),
                trailing: Text(
                  l.tacticsSubsUsed(_subsUsed, widget.maxSubs),
                  maxLines: 1,
                  style: AppTypography.labelMedium.copyWith(
                    color: _overLimit ? AppColors.error : AppColors.primary,
                  ),
                ),
                onSelected: (t) => setState(() => _tab = t),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    if (_tab == _SquadTab.onPitch)
                      for (final p in onPitch)
                        _OnPitchRow(
                          player: p,
                          detail: _pitchDetail(l, p.id),
                          energy: widget.energyByPlayer[p.id],
                          selected: comingOff?.id == p.id,
                          // Picking a man to come off moves the sheet to the
                          // men who could replace him. Otherwise choosing him
                          // and then hunting for the other tab is two thirds
                          // of the work of a substitution.
                          onTap: () => setState(() {
                            final same = _comingOff == p.id;
                            _comingOff = same ? null : p.id;
                            if (!same) _tab = _SquadTab.candidates;
                          }),
                        )
                    else if (available.isEmpty)
                      _emptyNote(l.tacticsNoSubs)
                    else
                      for (final p in available)
                        () {
                          final standing = _standing(p);
                          return SubDragRow(
                            player: p,
                            trailing: _energyTrailing(p.id),
                            note: standing.note,
                            noteColor: standing.color,
                            // Tapping completes a change the manager began by
                            // tapping the man he wants off. With nobody chosen
                            // there is nothing for a tap to mean, so the row
                            // does not pretend to answer one.
                            onTap: comingOff == null
                                ? null
                                : () => _replace(comingOff.id, p.id),
                          );
                        }(),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }

  /// What a list says when it has nothing in it.
  Widget _emptyNote(String text) => Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Text(
      text,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
  );

  /// Completes a tapped change: [inId] takes the place [outId] is standing in.
  ///
  /// [_setSlot] answers for it, exactly as the drop target does, so a tap can
  /// never make a change a drag would have been refused.
  void _replace(int outId, int inId) {
    final slot = _lineup.indexOf(outId);
    if (slot == -1) return;
    _setSlot(slot, inId);
  }

  /// What a row in ON THE PITCH says about how its man got there: he started,
  /// or he came on, and at what minute.
  String _pitchDetail(AppLocalizations l, int id) {
    if (widget.startingIds.contains(id)) return l.tacticsRowStarted;
    final at =
        widget.cameOnAt[id] ??
        // Brought on in THIS sheet, so the minute is the one on the clock.
        (_onPitchAtOpen.contains(id) ? null : widget.minute);
    return at == null ? l.tacticsRowSubstitute : l.tacticsRowCameOn(at);
  }

  /// What a squad list has to say about [p] BEFORE the manager picks him, and
  /// whether he may be picked at all.
  ///
  /// The rules themselves live in [refusalToBringOn] and are asked here, never
  /// restated: the lists used to show every player identically, so a manager
  /// learned that a man was already off, or that his changes were spent, only
  /// by being refused after he had chosen.
  ({String? note, Color color, bool blocked, SubRefusal refusal}) _standing(
    Player p,
  ) {
    final l = AppLocalizations.of(context);
    final refusal = refusalToBringOn(
      startingIds: widget.startingIds,
      onPitch: _onPitch,
      sentOffIds: widget.sentOffIds,
      withdrawnIds: _withdrawn,
      maxSubs: widget.maxSubs,
      playerId: p.id,
    );
    return switch (refusal) {
      SubRefusal.alreadyWithdrawn => (
        note: l.tacticsSubOffAlready,
        color: AppColors.error,
        blocked: true,
        refusal: refusal,
      ),
      // The MARKER, not the sentence. The full "… has been sent off and takes
      // no further part" belongs in the snackbar that refuses a gesture; in a
      // row it is a line of its own that no list column is wide enough for,
      // and it only started appearing in a list when the sent off were finally
      // shown in one.
      SubRefusal.sentOff => (
        note: l.tacticsSubSentOffMark,
        color: AppColors.error,
        blocked: true,
        refusal: refusal,
      ),
      SubRefusal.noSubsLeft => (
        note: l.tacticsSubNoneLeft,
        color: AppColors.error,
        blocked: true,
        refusal: refusal,
      ),
      // A knock does not stop a man playing: it is the manager's call whether
      // to risk him, so it is said in amber and he stays pickable.
      SubRefusal.none => (
        note: widget.injuredIds.contains(p.id) ? l.tacticsSubInjured : null,
        color: AppColors.warning,
        blocked: false,
        refusal: refusal,
      ),
    };
  }

  /// A small energy gauge for a squad row, or null when energy isn't tracked
  /// (pre-match) or this player has no recorded energy yet.
  Widget? _energyTrailing(int id) {
    final e = widget.energyByPlayer[id];
    if (e == null) return null;
    return _EnergyGauge(e);
  }

  /// Formation and the tactical instruction sliders.
  ///
  /// Shouting a side further forward when you are chasing a game is management,
  /// not an exploit — the sliders belong here. What does not belong is applying
  /// a whole prepared PLAYSTYLE mid-match, and that lives on the tactics screen
  /// rather than in this editor.
  Widget _tacticsTab() {
    final l = AppLocalizations.of(context);
    // Who takes what as things stand: the manager's own picks where he has
    // made them, and otherwise the man the engine steps up on its own.
    final live = _liveTakers;
    final xi = _onPitchPlayers;
    final penaltyId = live.penalty ?? SetPiecePicks.penalty(xi);
    final deadBallId = live.deadBall ?? SetPiecePicks.deadBall(xi);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        // The same control as before kick-off. Two different ways of picking
        // a shape — a row of text chips in here, a drawn grid out there — made
        // the same decision look like two unrelated features, and the text
        // chips are the version nobody could read: "4-1-4-1" and "4-4-1-1" are
        // one glyph apart and neither says what the side would look like.
        FormationField(
          selected: _formation,
          onSelected: _setFormation,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l.tacticsInstructions, style: AppTypography.labelMedium),
        _slider(
          l.tacticsInstrMentality,
          l.tacticsInstrDefensive,
          l.tacticsInstrAttacking,
          _instructions.mentality,
          (v) => _instructions = _instructions.copyWith(mentality: v),
        ),
        _slider(
          l.tacticsInstrPressing,
          l.tacticsInstrLowBlock,
          l.tacticsInstrHighPress,
          _instructions.pressing,
          (v) => _instructions = _instructions.copyWith(pressing: v),
        ),
        _slider(
          l.tacticsInstrTempo,
          l.tacticsInstrPatient,
          l.tacticsInstrFast,
          _instructions.tempo,
          (v) => _instructions = _instructions.copyWith(tempo: v),
        ),
        _slider(
          l.tacticsInstrWidth,
          l.tacticsInstrNarrow,
          l.tacticsInstrWide,
          _instructions.width,
          (v) => _instructions = _instructions.copyWith(width: v),
        ),
        _slider(
          l.tacticsInstrDefLine,
          l.tacticsInstrDeep,
          l.tacticsInstrHigh,
          _instructions.defensiveLine,
          (v) => _instructions = _instructions.copyWith(defensiveLine: v),
        ),
        _slider(
          l.tacticsInstrDirectness,
          l.tacticsInstrPossession,
          l.tacticsInstrDirect,
          _instructions.directness,
          (v) => _instructions = _instructions.copyWith(directness: v),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Set-piece takers, live. The pair was fixed at kick-off and could not
        // be touched again, so a manager whose penalty taker had just been
        // substituted (or had just put one over the bar) had no way to hand the
        // ball to anyone else. Only the eleven ON THE PITCH are offered: a
        // designated taker sitting on the bench is ignored by the engine
        // anyway, and offering him would read as a change that did nothing.
        Text(l.tacticsSetPieceTakers, style: AppTypography.labelMedium),
        const SizedBox(height: 2),
        Text(
          l.tacticsSetPieceBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            children: [
              // Who steps up as things stand. The engine has always had an
              // answer; only the screen was blank.
              SetPieceTakerSummary(
                penaltyName: _byId[penaltyId]?.name,
                penaltyIsAuto: live.penalty == null,
                deadBallName: _byId[deadBallId]?.name,
                deadBallIsAuto: live.deadBall == null,
                // One tap takes the two men already named above and makes them
                // the manager's own. They are the same names either way; what
                // changes is that they are now a decision, and they stop
                // drifting with the eleven as it is picked apart by
                // substitutions.
                onQuickPick: () => setState(() {
                  _takers = (penalty: penaltyId, deadBall: deadBallId);
                }),
              ),
              const Divider(height: AppSpacing.lg),
              for (final p in _onPitchPlayers)
                _TakerRow(
                  player: p,
                  isPenaltyTaker: live.penalty == p.id,
                  isDeadBallTaker: live.deadBall == p.id,
                  isAutoPenalty: live.penalty == null && penaltyId == p.id,
                  isAutoDeadBall: live.deadBall == null && deadBallId == p.id,
                  onTogglePenalty: () => setState(() {
                    _takers = (
                      penalty: live.penalty == p.id ? null : p.id,
                      deadBall: live.deadBall,
                    );
                  }),
                  onToggleDeadBall: () => setState(() {
                    _takers = (
                      penalty: live.penalty,
                      deadBall: live.deadBall == p.id ? null : p.id,
                    );
                  }),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _slider(
    String label,
    String low,
    String high,
    int value,
    ValueChanged<int> apply,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.bodyMedium),
            const Spacer(),
            Text('$value', style: AppTypography.labelMedium),
          ],
        ),
        Slider(
          value: value.toDouble(),
          max: 100,
          divisions: 20,
          onChanged: (v) => setState(() => apply(v.round())),
        ),
        Row(
          children: [
            Text(
              low,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              high,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  /// A cross-line drag that reshapes: refit the current players to [next], then
  /// nudge the dragged player toward the target slot so the intent is kept.
  void _reshapeKeeping(Formation next, int a, int b) {
    final draggedId = _lineup[a];
    _setFormation(next);
    if (draggedId != null) {
      final slot = _lineup.indexOf(draggedId);
      // If the player didn't land near the target line, place them at b.
      if (slot != -1 && slot != b) _setSlot(b, draggedId);
    }
  }

  Future<void> _pickPlayer(int slot) async {
    if (_dead.contains(slot)) {
      _refuse(AppLocalizations.of(context).tacticsSlotLostToRedCard);
      return;
    }
    final position = _formation.positions[slot];
    final isKeeperSlot = position.category == PositionCategory.goalkeeper;
    // A goalkeeping slot is keeper-only; any other slot can be filled by any
    // outfield player (with a heavy out-of-position penalty, shown below).
    final candidates =
        _eligible
            .where(
              (p) => isKeeperSlot
                  ? p.position.category == PositionCategory.goalkeeper
                  : p.position.category != PositionCategory.goalkeeper,
            )
            .toList()
          ..sort(PositionFit.bySlotFit(position));
    final onPitch = _onPitch;
    final l = AppLocalizations.of(context);

    // Split the way the bench below the pitch is split, and for the reason it
    // was split: this sheet offered a man already taken off exactly as it
    // offered a fit substitute, and a manager reported it as "offering
    // everyone". The bench list was given sections and this was not, which
    // left the GRAPHICAL route to a substitution, the one most people take,
    // still reading like the old flat list.
    //
    // Inside each section the order stays PositionFit: this sheet is about
    // one slot, so who suits that slot is the question, and rating order
    // would answer a different one.
    final onPitchHere = [
      for (final p in candidates)
        if (onPitch.contains(p.id)) p,
    ];
    final availableHere = [
      for (final p in candidates)
        if (!onPitch.contains(p.id) && !_standing(p).blocked) p,
    ];

    Widget head(String text) => Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.xs,
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    Widget emptyNote(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );

    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l.tacticsPickRole(position.roleName.toUpperCase()),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          if (onPitchHere.isNotEmpty)
            head(l.tacticsSectionOnPitch(onPitch.length, _lineup.length)),
          for (final p in onPitchHere) _pickerRow(p, position, onPitch, l),
          head(l.tacticsSectionAvailable(availableHere.length)),
          if (availableHere.isEmpty) emptyNote(l.tacticsNoSubs),
          for (final p in availableHere) _pickerRow(p, position, onPitch, l),
        ],
      ),
    );
    if (picked != null && mounted) _setSlot(slot, picked);
  }

  /// One candidate's row in the slot picker.
  Widget _pickerRow(
    Player p,
    PlayerPosition position,
    Set<int> onPitch,
    AppLocalizations l,
  ) => () {
    final eff = PositionFit.effectiveOverall(p, position);
    final penalised = eff < p.overall;
    // The same standing the squad list shows. This is the list the
    // manager actually picks from, and it offered a man already
    // taken off exactly as it offered a fit substitute.
    final standing = _standing(p);
    return ListTile(
      dense: true,
      enabled: !standing.blocked,
      leading: TacticalChip(p.position.label),
      title: Text(
        p.name,
        style: AppTypography.bodyMedium.copyWith(
          color: onPitch.contains(p.id) || standing.blocked
              ? AppColors.onSurfaceVariant
              : null,
        ),
      ),
      // Age, and only age. The row ALREADY says he is out of
      // position twice over: the leading chip names the position he
      // actually plays, and the trailing rating is docked and amber
      // with his real overall in brackets behind it. Saying it a
      // third time in amber words made the row shout, and the amber
      // that matters — the number the match is decided on — stopped
      // standing out for being one of three.
      //
      // What DOES belong beside the age is the one thing the list
      // never said: whether he may come on at all.
      subtitle: Text(
        standing.note == null
            ? l.tacticsAgeOnly(p.age)
            : '${l.tacticsAgeOnly(p.age)} · ${standing.note}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(
          color: standing.note == null
              ? AppColors.onSurfaceVariant
              : standing.color,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onPitch.contains(p.id)) ...[
            TacticalChip(l.tacticsOn),
            const SizedBox(width: AppSpacing.sm),
          ],
          // The rating in THIS slot leads — the number that decides
          // the match — in amber when it is a docked one, with the
          // player's own overall behind it for the comparison.
          Text(
            '$eff',
            style: AppTypography.labelMedium.copyWith(
              color: penalised ? AppColors.warning : null,
            ),
          ),
          if (penalised)
            Text(
              ' (${p.overall})',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
        ],
      ),
      onTap: standing.blocked ? null : () => Navigator.of(context).pop(p.id),
    );
  }();
}

/// Which half of the squad the sheet is showing.
enum _SquadTab { candidates, onPitch }

/// The two-way switch over the squad list, with the changes left beside it.
///
/// Chips rather than a TabBar: a TabBarView inside the scrolling sheet needs
/// a bounded height of its own, and giving it one is what makes a list end up
/// with its own private scrollbar inside a page that already scrolls.
class _SquadTabs extends StatelessWidget {
  const _SquadTabs({
    required this.onPitch,
    required this.onPitchLabel,
    required this.candidatesLabel,
    required this.trailing,
    required this.onSelected,
  });

  final bool onPitch;
  final String onPitchLabel;
  final String candidatesLabel;
  final Widget trailing;
  final ValueChanged<_SquadTab> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.md),
    child: Row(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Chip(
                  label: candidatesLabel,
                  selected: !onPitch,
                  onTap: () => onSelected(_SquadTab.candidates),
                ),
                const SizedBox(width: AppSpacing.xs),
                _Chip(
                  label: onPitchLabel,
                  selected: onPitch,
                  onTap: () => onSelected(_SquadTab.onPitch),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        trailing,
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: AppRadii.smAll,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.secondaryContainer : null,
        borderRadius: AppRadii.smAll,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.outlineVariant,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: AppTypography.labelSmall.copyWith(
          color: selected
              ? AppColors.onSecondaryContainer
              : AppColors.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ),
  );
}

/// One of the eleven, in the list under the pitch.
///
/// Not a [SubDragRow]: the questions are different ones. A bench row asks
/// "may he come on, and what is wrong with him"; this one answers "is he a
/// starter or did he come on, and when" — the half of the team sheet that was
/// nowhere on this screen at all, because who was playing appeared only as
/// eleven discs on the pitch above.
class _OnPitchRow extends StatelessWidget {
  const _OnPitchRow({
    required this.player,
    required this.detail,
    required this.energy,
    required this.selected,
    required this.onTap,
  });

  final Player player;

  /// How he got here: "Started", or the minute he came on.
  final String detail;

  /// His remaining energy, or null when energy is not being tracked.
  final int? energy;

  /// Whether the manager has tapped him to come off and is now choosing who
  /// replaces him.
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    // Its own, and transparent: an [AppCard] that is not itself tappable is a
    // plain DecoratedBox, so the nearest Material is the Scaffold's — and a
    // ripple painted down there comes out UNDER the card and is never seen.
    type: MaterialType.transparency,
    child: InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceContainerHighest : null,
          // The same active bar a selected data-list row wears everywhere
          // else, so "this is the man I am taking off" needs no explaining.
          border: Border(
            left: BorderSide(
              color: selected ? AppColors.activeBar : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              SizedBox(width: 40, child: TacticalChip(player.position.label)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Never cut: a name that ends in an ellipsis is not a name,
                    // and this list is read to find a man by his.
                    WholeText(
                      player.name,
                      maxLines: 1,
                      shortText: initialledName(player.name),
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      detail,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (energy != null) ...[
                const SizedBox(width: AppSpacing.sm),
                _EnergyGauge(energy!),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

/// What a player has left, with the word ENERGY over it.
///
/// The number used to stand on its own — "mam len tie percenta", the manager
/// said: he had only the percentages, and nothing saying what they were of.
class _EnergyGauge extends StatelessWidget {
  const _EnergyGauge(this.energy);

  final int energy;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = energyColor(energy);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          l.tacticsEnergyLabel,
          maxLines: 1,
          style: AppTypography.labelSmall.copyWith(
            // Small on purpose: it is a caption on a number, and the number is
            // what a manager is reading. A full-size word here would take the
            // width off the name beside it on a 320px phone.
            fontSize: 9,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, size: 14, color: color),
            Text(
              '$energy%',
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ],
        ),
      ],
    );
  }
}

/// One player on the pitch, with the two set-piece badges beside him. The same
/// controls as the tactics screen before kick-off, minus the role picker: a
/// role is a brief you give a player, not a call you make at 70 minutes.
class _TakerRow extends StatelessWidget {
  const _TakerRow({
    required this.player,
    required this.isPenaltyTaker,
    required this.isDeadBallTaker,
    required this.isAutoPenalty,
    required this.isAutoDeadBall,
    required this.onTogglePenalty,
    required this.onToggleDeadBall,
  });

  final Player player;
  final bool isPenaltyTaker;
  final bool isDeadBallTaker;

  /// Nobody has been named and this is the man the engine would pick.
  final bool isAutoPenalty;
  final bool isAutoDeadBall;
  final VoidCallback onTogglePenalty;
  final VoidCallback onToggleDeadBall;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 36, child: TacticalChip(player.position.label)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            // The name of the man who takes the penalty is the whole point of
            // this row, and a Text with an ellipsis handed the manager
            // "Vondrackovs..." at 360 points. [WholeText] gives up the
            // forename before it gives up anything else, and its size before
            // it gives up a letter.
            child: WholeText(
              player.name,
              maxLines: 1,
              shortText: initialledName(player.name),
              style: AppTypography.bodyMedium,
            ),
          ),
          // Technical ability, the quality that decides a penalty or a free
          // kick, so the choice is made on a number rather than a hunch.
          Text(
            '${player.attributes.technical}',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.ratingColor(player.attributes.technical / 10),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SetPieceBadge(
            icon: Icons.sports_soccer,
            active: isPenaltyTaker,
            auto: isAutoPenalty,
            tooltip: l.tacticsPenalties,
            onTap: onTogglePenalty,
          ),
          const SizedBox(width: 6),
          SetPieceBadge(
            icon: Icons.flag_rounded,
            active: isDeadBallTaker,
            auto: isAutoDeadBall,
            tooltip: l.tacticsCornersFreeKicks,
            onTap: onToggleDeadBall,
          ),
        ],
      ),
    );
  }
}
