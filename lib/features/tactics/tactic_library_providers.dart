import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/player_roles_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

/// Every tactic in the manager's library, alphabetically. Not per career: the
/// library is the same list in every save.
final AutoDisposeFutureProvider<List<LibraryTactic>> tacticLibraryProvider =
    FutureProvider.autoDispose<List<LibraryTactic>>(
      (ref) => ref.watch(tacticLibraryRepositoryProvider).all(),
    );

/// Saves to, loads from, renames and deletes from the tactics library.
class TacticLibraryService {
  const TacticLibraryService(this._ref);

  final Ref _ref;

  Future<void> _saved(Future<void> write) async {
    await write;
    _ref.invalidate(tacticLibraryProvider);
  }

  /// Saves [careerId]'s current tactic, with its roles and set-piece takers
  /// recorded by slot, under [name]. False when the save has no tactic.
  Future<bool> saveCurrent(int careerId, String name) async {
    final tactic = await _ref
        .read(tacticsRepositoryProvider)
        .tacticForCareer(careerId);
    if (tactic == null) return false;
    final roles = await _ref.read(playerRolesStoreProvider).load(careerId);
    final takers = await _ref.read(setPieceTakersStoreProvider).load(careerId);
    await _saved(
      _ref
          .read(tacticLibraryRepositoryProvider)
          .save(
            LibraryTactic.capture(
              name: name,
              tactic: tactic,
              roles: roles,
              penaltyTaker: takers.penalty,
              deadBallTaker: takers.deadBall,
            ),
          ),
    );
    return true;
  }

  /// Copies one save's [preset] into the library under [name]. A preset is a
  /// shape and the six dials, so that is all the entry carries.
  Future<void> savePreset(TacticPreset preset, String name) => _saved(
    _ref
        .read(tacticLibraryRepositoryProvider)
        .save(
          LibraryTactic(
            name: name,
            formation: preset.formation,
            instructions: preset.instructions,
            playstyle: PlaystyleX.matching(preset.instructions),
            fullBacks: preset.fullBacks,
          ),
        ),
  );

  /// Loads [tactic] into [careerId]; see [TacticService.applyLibraryTactic].
  Future<LibraryFit?> apply(int careerId, LibraryTactic tactic) =>
      _ref.read(tacticServiceProvider).applyLibraryTactic(careerId, tactic);

  /// Renames entry [id]. False when another entry already has [name].
  Future<bool> rename(int id, String name) async {
    final ok = await _ref
        .read(tacticLibraryRepositoryProvider)
        .rename(id, name);
    if (ok) _ref.invalidate(tacticLibraryProvider);
    return ok;
  }

  Future<void> delete(int id) =>
      _saved(_ref.read(tacticLibraryRepositoryProvider).delete(id));
}

final Provider<TacticLibraryService> tacticLibraryServiceProvider = Provider(
  TacticLibraryService.new,
);
