import 'package:fnm/domain/entities/enums.dart';

/// Supported team shapes. Each maps to 11 on-pitch positions (slot order:
/// goalkeeper, defence, midfield, attack).
enum Formation { f442, f433, f352, f4231, f532 }

extension FormationX on Formation {
  /// Human-readable label, e.g. `4-3-3`.
  String get label => switch (this) {
        Formation.f442 => '4-4-2',
        Formation.f433 => '4-3-3',
        Formation.f352 => '3-5-2',
        Formation.f4231 => '4-2-3-1',
        Formation.f532 => '5-3-2',
      };

  /// The 11 positions for this formation, in slot order.
  List<PlayerPosition> get positions => switch (this) {
        Formation.f442 => const [
            PlayerPosition.gk,
            PlayerPosition.lb,
            PlayerPosition.cb,
            PlayerPosition.cb,
            PlayerPosition.rb,
            PlayerPosition.lm,
            PlayerPosition.cm,
            PlayerPosition.cm,
            PlayerPosition.rm,
            PlayerPosition.st,
            PlayerPosition.st,
          ],
        Formation.f433 => const [
            PlayerPosition.gk,
            PlayerPosition.lb,
            PlayerPosition.cb,
            PlayerPosition.cb,
            PlayerPosition.rb,
            PlayerPosition.dm,
            PlayerPosition.cm,
            PlayerPosition.cm,
            PlayerPosition.lw,
            PlayerPosition.st,
            PlayerPosition.rw,
          ],
        Formation.f352 => const [
            PlayerPosition.gk,
            PlayerPosition.cb,
            PlayerPosition.cb,
            PlayerPosition.cb,
            PlayerPosition.lm,
            PlayerPosition.cm,
            PlayerPosition.cm,
            PlayerPosition.cm,
            PlayerPosition.rm,
            PlayerPosition.st,
            PlayerPosition.st,
          ],
        Formation.f4231 => const [
            PlayerPosition.gk,
            PlayerPosition.lb,
            PlayerPosition.cb,
            PlayerPosition.cb,
            PlayerPosition.rb,
            PlayerPosition.dm,
            PlayerPosition.cm,
            PlayerPosition.am,
            PlayerPosition.lw,
            PlayerPosition.rw,
            PlayerPosition.st,
          ],
        Formation.f532 => const [
            PlayerPosition.gk,
            PlayerPosition.lb,
            PlayerPosition.cb,
            PlayerPosition.cb,
            PlayerPosition.cb,
            PlayerPosition.rb,
            PlayerPosition.cm,
            PlayerPosition.cm,
            PlayerPosition.cm,
            PlayerPosition.st,
            PlayerPosition.st,
          ],
      };
}
