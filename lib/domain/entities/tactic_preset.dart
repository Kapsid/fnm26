import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';

/// A named, reusable tactical style — a shape plus the six instruction sliders,
/// saved once and applied to any save. The XI is deliberately not part of a
/// preset: it depends on who's called up, so applying a preset re-fits the best
/// available eleven to the shape.
class TacticPreset {
  const TacticPreset({
    required this.name,
    required this.formation,
    required this.instructions,
  });

  final String name;
  final Formation formation;
  final TacticalInstructions instructions;

  Map<String, dynamic> toJson() => {
    'name': name,
    'formation': formation.name,
    'mentality': instructions.mentality,
    'pressing': instructions.pressing,
    'tempo': instructions.tempo,
    'width': instructions.width,
    'defensiveLine': instructions.defensiveLine,
    'directness': instructions.directness,
  };

  static TacticPreset? fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    if (name is! String || name.isEmpty) return null;
    final formation = Formation.values.firstWhere(
      (f) => f.name == json['formation'],
      orElse: () => Formation.values.first,
    );
    int slider(String key) {
      final v = json[key];
      return v is int ? v.clamp(0, 100) : 50;
    }

    return TacticPreset(
      name: name,
      formation: formation,
      instructions: TacticalInstructions(
        mentality: slider('mentality'),
        pressing: slider('pressing'),
        tempo: slider('tempo'),
        width: slider('width'),
        defensiveLine: slider('defensiveLine'),
        directness: slider('directness'),
      ),
    );
  }
}
