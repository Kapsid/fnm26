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

    /// Short country code (e.g. `BRA`, `ENG`): the real FIFA key flags, the
    /// nation's identity and every data table are keyed on. Never print it
    /// as text; print [shortCode].
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

    /// The host bids this nation has lodged in the career it was read for,
    /// keyed `wc:<cycle>` / `cont:<cycle>` (see `HostBidding.nationKey`), each
    /// the winning chance in permille the manager was shown. Attached by
    /// `NationRepository.forCareer` from the career's markers; empty
    /// everywhere else, which leaves every host draw exactly as it was.
    ///
    /// Also carries the career's host-rules markers on the nation each names,
    /// keyed `mgr:<cycle>` (see `HostBidding.managerKey`, value 1).
    @Default(<String, int>{}) Map<String, int> hostBids,

    /// The 3-letter code the career's custom world gives this nation, empty
    /// when it gives none (always, in the default world). See [shortCode].
    @Default('') String displayCode,
  }) = _Nation;

  const Nation._();

  factory Nation.fromJson(Map<String, Object?> json) => _$NationFromJson(json);

  /// The code to PRINT: the world's [displayCode], else the real [code].
  String get shortCode => displayCode.isEmpty ? code : displayCode;
}
