import 'package:fnm/domain/entities/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nation.freezed.dart';
part 'nation.g.dart';

/// A national team that can be managed or faced.
///
/// [isFreeDemo] gates demo content: only free-demo nations are selectable
/// until the premium unlock is purchased.
@freezed
abstract class Nation with _$Nation {
  const factory Nation({
    required int id,

    /// The name to SHOW — already resolved for the app's language (see
    /// `NationNames`). Everything user-facing prints this.
    required String name,

    /// Short country code (e.g. `BRA`, `ENG`).
    required String code,
    required Confederation confederation,

    /// FIFA-style ranking position (lower is stronger).
    required int ranking,

    /// Whether this nation is available in the free demo.
    @Default(false) bool isFreeDemo,

    /// The national team's home-kit colours as `#RRGGBB` hex — primary (shirt)
    /// and secondary (trim). Defined for every FIFA nation; the defaults are
    /// only a fallback for a nation constructed without them (e.g. in tests).
    @Default('#1E88E5') String primaryColor,
    @Default('#FFFFFF') String secondaryColor,

    /// The canonical ENGLISH name as stored in the seed data, whatever the UI
    /// language. A handful of things resolve a nation by name rather than by
    /// id — the real-history seeder above all — and those must not start
    /// missing every country the moment the app is switched to Czech.
    /// Empty means "same as [name]".
    @Default('') String englishName,
  }) = _Nation;

  factory Nation.fromJson(Map<String, Object?> json) => _$NationFromJson(json);
}
