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
  });

  /// Preferred number of teams per group (group count derives from this).
  final int targetGroupSize;

  /// Direct qualification berths for the confederation (display/standings use).
  final int directBerths;

  /// World Cup finals places allocated to the confederation. Across all six
  /// these sum to 32 (a clean 8-group finals).
  final int finalsBerths;

  static const _byConfederation = <Confederation, QualificationFormat>{
    Confederation.europe: QualificationFormat(
      targetGroupSize: 5,
      directBerths: 16,
      finalsBerths: 13,
    ),
    Confederation.southAmerica: QualificationFormat(
      targetGroupSize: 10,
      directBerths: 6,
      finalsBerths: 4,
    ),
    Confederation.northAmerica: QualificationFormat(
      targetGroupSize: 6,
      directBerths: 6,
      finalsBerths: 5,
    ),
    Confederation.africa: QualificationFormat(
      targetGroupSize: 6,
      directBerths: 9,
      finalsBerths: 5,
    ),
    Confederation.asia: QualificationFormat(
      targetGroupSize: 6,
      directBerths: 8,
      finalsBerths: 4,
    ),
    Confederation.oceania: QualificationFormat(
      targetGroupSize: 11,
      directBerths: 1,
      finalsBerths: 1,
    ),
  };

  static QualificationFormat forConfederation(Confederation c) =>
      _byConfederation[c]!;

  /// Total finals places across every confederation (32).
  static int get totalFinalsBerths =>
      _byConfederation.values.fold(0, (s, f) => s + f.finalsBerths);
}
