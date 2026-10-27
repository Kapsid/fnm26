// Regenerates lib/domain/services/competition/national_stadium_data.dart from
// assets/data/national_stadiums.json, the curated source:
//
//   dart run tool/gen_national_stadium_data.dart && dart format <that file>
//
// test/unit/federation/national_stadium_data_test.dart fails whenever the two
// disagree.
import 'dart:convert';
import 'dart:io';

void main() {
  final json =
      jsonDecode(File('assets/data/national_stadiums.json').readAsStringSync())
          as Map<String, Object?>;
  String esc(String s) =>
      s.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$');
  final ids = [for (final k in json.keys) int.parse(k)]..sort();
  final out = StringBuffer()
    ..writeln(
      '// GENERATED from assets/data/national_stadiums.json by '
      'tool/gen_national_stadium_data.dart.',
    )
    ..writeln(
      '// Edit the JSON and regenerate; '
      'test/unit/federation/national_stadium_data_test.dart',
    )
    ..writeln('// fails if the two ever disagree.')
    ..writeln()
    ..writeln(
      '/// Every nation\'s real top grounds, biggest first, up to ten: the city',
    )
    ..writeln(
      '/// each stands in (one of the nation\'s venue cities) and its approximate',
    )
    ..writeln(
      '/// real capacity. A city may appear twice (London, Lima, Abidjan). See',
    )
    ..writeln(
      '/// `VenueGenerator.forHost`, which seeds every estate and venue from it.',
    )
    ..writeln('const Map<int, List<(String, int)>> nationalStadiumData = {');
  for (final id in ids) {
    final list = (json['$id']! as List).cast<Map<String, Object?>>();
    final items = [
      for (final e in list) "('${esc(e['city']! as String)}', ${e['seats']})",
    ].join(', ');
    out.writeln('  $id: [$items],');
  }
  out.writeln('};');
  File(
    'lib/domain/services/competition/national_stadium_data.dart',
  ).writeAsStringSync(out.toString());
}
