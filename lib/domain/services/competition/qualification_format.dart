import 'package:fnm/domain/entities/enums.dart';

/// Per-confederation World Cup qualification shape.
///
/// "Realistic" formats differ a lot, so they're expressed as config consumed by
/// the generic schedule generator rather than six hand-coded paths. v1 models
/// each confederation as round-robin groups of a target size (CONMEBOL/OFC = a
/// single league). Multi-stage confederations are simplified to one group stage
/// and can be refined later without changing the generator.
class QualificationFormat {
  const QualificationFormat({
    required this.targetGroupSize,
    required this.directBerths,
    required this.finalsBerths,
    this.playoffEntrants = 0,
  });

  /// Preferred number of teams per group (group count derives from this).
  final int targetGroupSize;

  /// Direct qualification berths for the confederation (display/standings use).
  final int directBerths;

  /// Direct World Cup finals places allocated to the confederation. Across all
  /// six these sum to 46; the remaining two of the 48-team finals are decided
  /// by the intercontinental playoff (see [playoffEntrants]).
  final int finalsBerths;

  /// Teams the confederation sends to the six-team intercontinental playoff,
  /// which awards the final two finals places. Mirrors the real 2026 format
  /// (2 from CONCACAF, 1 each from CONMEBOL/CAF/AFC/OFC).
  final int playoffEntrants;

  static const _byConfederation = <Confederation, QualificationFormat>{
    Confederation.europe: QualificationFormat(
      targetGroupSize: 5,
      directBerths: 16,
      finalsBerths: 16,
    ),
    Confederation.southAmerica: QualificationFormat(
      targetGroupSize: 10,
      directBerths: 6,
      finalsBerths: 6,
      playoffEntrants: 1,
    ),
    Confederation.northAmerica: QualificationFormat(
      targetGroupSize: 6,
      directBerths: 6,
      finalsBerths: 6,
      playoffEntrants: 2,
    ),
    Confederation.africa: QualificationFormat(
      targetGroupSize: 6,
      directBerths: 9,
      finalsBerths: 9,
      playoffEntrants: 1,
    ),
    Confederation.asia: QualificationFormat(
      targetGroupSize: 6,
      directBerths: 8,
      finalsBerths: 8,
      playoffEntrants: 1,
    ),
    Confederation.oceania: QualificationFormat(
      // Two small groups, not one 11-team league — a single group would run 22
      // matchdays and spill past the finals window.
      targetGroupSize: 6,
      directBerths: 1,
      finalsBerths: 1,
      playoffEntrants: 1,
    ),
  };

  static QualificationFormat forConfederation(Confederation c) =>
      _byConfederation[c]!;

  /// The two finals places decided by the intercontinental playoff.
  static const playoffBerths = 2;

  /// Direct finals places across every confederation (46). With
  /// [playoffBerths] this makes the 48-team finals.
  static int get totalFinalsBerths =>
      _byConfederation.values.fold(0, (s, f) => s + f.finalsBerths);
}
