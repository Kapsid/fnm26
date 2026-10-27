import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One nation's map: its outline, the cities the stadium map may pin, the
/// box the map opens on and any inset (a far island with a city on it, such
/// as Madeira for Portugal).
///
/// Built offline from Natural Earth (public domain) by `tool/geo/gen_geo.py`
/// into `assets/geo/<nation id>.json`, one small file per nation, so showing
/// a nation never reads the world.
///
/// Positions are in a flat "map plane": equirectangular, x scaled by the
/// cosine of the view's middle latitude, y growing south, with the view's
/// top-left corner at the origin. Longitudes past 180 are kept as they are,
/// so a nation across the antimeridian (Fiji) stays in one piece.
class NationGeo {
  NationGeo._({
    required this.north,
    required this.west,
    required this.k,
    required this.view,
    required this.insets,
    required this.rings,
    required this.cities,
  });

  /// Parses the asset format (see `tool/geo/gen_geo.py`).
  factory NationGeo.fromJson(Map<String, Object?> json) {
    final s = (json['s']! as num).toDouble();
    List<double> box(Object? raw) => [
      for (final v in raw! as List) (v as num) / s,
    ];
    final v = box(json['v']);
    final k = math.cos((v[1] + v[3]) / 2 * math.pi / 180);
    final west = v[0];
    final north = v[3];
    Offset plane(double lon, double lat) =>
        Offset((lon - west) * k, north - lat);
    Rect rect(List<double> b) =>
        Rect.fromPoints(plane(b[0], b[3]), plane(b[2], b[1]));

    final rings = <List<Offset>>[];
    for (final raw in json['r']! as List) {
      final r = raw as List;
      var x = (r[0] as num).toInt();
      var y = (r[1] as num).toInt();
      final pts = <Offset>[plane(x / s, y / s)];
      for (var i = 2; i + 1 < r.length; i += 2) {
        x += (r[i] as num).toInt();
        y += (r[i + 1] as num).toInt();
        pts.add(plane(x / s, y / s));
      }
      rings.add(pts);
    }
    final cities = <String, Offset>{
      for (final e in (json['c']! as Map<String, Object?>).entries)
        e.key: plane(
          ((e.value! as List)[0] as num) / s,
          ((e.value! as List)[1] as num) / s,
        ),
    };
    return NationGeo._(
      north: north,
      west: west,
      k: k,
      view: rect(v),
      insets: [for (final b in json['i']! as List) rect(box(b))],
      rings: rings,
      cities: cities,
    );
  }

  /// The latitude and longitude of the plane's origin, and the cosine its
  /// x is scaled by: what a graticule is drawn from.
  final double north;
  final double west;
  final double k;

  /// The box the map opens on: the main landmass and every city pinned on
  /// it, padded. Its top-left corner is the plane's origin.
  final Rect view;

  /// Boxes for far outposts, each drawn as a small framed inset.
  final List<Rect> insets;

  /// Outline rings, holes included (fill even-odd).
  final List<List<Offset>> rings;

  /// Every city the map may pin, by the name the game gives it.
  final Map<String, Offset> cities;

  Path? _path;

  /// The whole outline as one path, built once and kept.
  Path get path => _path ??= _buildPath();

  Path _buildPath() {
    final p = Path()..fillType = PathFillType.evenOdd;
    for (final r in rings) {
      if (r.length < 3) continue;
      p.addPolygon(r, true);
    }
    return p;
  }

  /// Which box [city] is drawn in: -1 for the main view, else the inset's
  /// index; null when the city has no position.
  int? boxOf(String city) {
    final c = cities[city];
    if (c == null) return null;
    for (var i = 0; i < insets.length; i++) {
      if (insets[i].contains(c)) return i;
    }
    return -1;
  }
}

/// The asset for [nationId].
String nationGeoAsset(int nationId) => 'assets/geo/$nationId.json';

/// Reads and parses one nation's map, once per nation for the app's life
/// (each is a few kilobytes, and the paths are cached inside). Null when the
/// nation has no map file.
final FutureProviderFamily<NationGeo?, int> nationGeoProvider =
    FutureProvider.family<NationGeo?, int>((ref, nationId) async {
      final ByteData data;
      try {
        data = await rootBundle.load(nationGeoAsset(nationId));
      } on Object {
        return null;
      }
      // Decoded here, not with loadString: that hands big files to an
      // isolate, which a widget test's fake clock never lets finish.
      final text = utf8.decode(data.buffer.asUint8List());
      return NationGeo.fromJson(jsonDecode(text) as Map<String, Object?>);
    });
