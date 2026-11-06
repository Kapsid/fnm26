/// The silhouette drawn behind the far stand. Task 12 fills in the curated
/// cities; until then every ground gets [none] (a generic skyline).
enum LandmarkKind { none }

abstract final class Landmarks {
  static LandmarkKind forCity(String city) => LandmarkKind.none;
}
