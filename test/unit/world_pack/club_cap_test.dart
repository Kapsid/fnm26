import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

const _added = kPackAddedIdBase;

List<PackPlayer> _squad() {
  var id = 1;
  PackPlayer p(PlayerPosition pos) => PackPlayer(
    id: id++,
    name: 'Player $id',
    age: 25,
    position: pos,
    attributes: const PlayerAttributes(
      physical: 60,
      technical: 60,
      stamina: 60,
    ),
    potential: 90,
  );
  return [
    for (var i = 0; i < 3; i++) p(PlayerPosition.gk),
    for (var i = 0; i < 7; i++) p(PlayerPosition.cb),
    for (var i = 0; i < 10; i++) p(PlayerPosition.cm),
    for (var i = 0; i < 3; i++) p(PlayerPosition.st),
  ];
}

WorldPack _pack({
  List<PackClub> addedClubs = const [],
  Map<String, String> clubs = const {},
  Map<String, int> clubStrengths = const {},
}) => WorldPack(
  uuid: 'u',
  name: 'n',
  author: 'a',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  squads: {1: _squad()},
  clubs: clubs,
  clubStrengths: clubStrengths,
  addedClubs: addedClubs,
);

/// The check [PackRules.clubNameClash] made before the index (1.1.0
/// editor 2), word for word: the reference the index must agree with.
ClubNameClash? _naive(
  WorldPack p,
  String name,
  String country,
  Map<String, List<String>> countryCities, {
  int? addedId,
  String? renamedFrom,
}) {
  String fold(String s) => s.trim().toLowerCase();
  final to = fold(name);
  if (renamedFrom != null && fold(renamedFrom) == to) return null;
  final code = country.toLowerCase();
  if (p.addedClubs.any(
    (c) => c.country == code && c.id != addedId && fold(c.name) == to,
  )) {
    return ClubNameClash.added;
  }
  var game = false;
  for (final original in ClubService.leagueClubs(code)) {
    if (original == renamedFrom) continue;
    switch (p.clubs[original]) {
      case final renamed? when renamed.trim().isNotEmpty:
        if (fold(renamed) == to) return ClubNameClash.renamed;
      case _:
        if (fold(original) == to) game = true;
    }
  }
  if (game ||
      ClubService.domesticClubNames(
        code,
        countryCities[code] ?? const [],
      ).any((c) => fold(c) == to)) {
    return ClubNameClash.game;
  }
  if (p.clubs.keys.any((k) => k != renamedFrom && fold(k) == to)) {
    return ClubNameClash.renameKey;
  }
  final all = {
    for (final l in ClubService.allLeagues())
      for (final c in l.clubs) fold(c),
  };
  if (all.contains(to)) return ClubNameClash.gameElsewhere;
  return null;
}

/// [n] added clubs over a spread of countries, some under the same name as
/// another (a duplicate), some under a game club's.
List<PackClub> _many(int n) {
  final codes = ['cze', 'eng', 'and', 'cro', 'zzz', 'bra', 'fij', 'aia'];
  final eng = ClubService.leagueClubs('eng');
  return [
    for (var i = 0; i < n; i++)
      PackClub(
        id: _added + i,
        name: i % 97 == 0
            ? eng[i % eng.length]
            : i % 89 == 0
            ? 'Club ${i - 8}'
            : 'Club $i',
        country: codes[i % codes.length],
        strength: i % 7 == 0 ? 1 + i % 5 : null,
      ),
  ];
}

void main() {
  test('the cap is 5 000 added clubs: 5 000 pass, 5 001 do not', () {
    expect(PackRules.addedClubsMax, 5000);
    BadField? capIssue(int n) => PackRules.issues(
      _pack(addedClubs: _many(n)),
    ).whereType<BadField>().where((b) => b.path == 'addedClubs').firstOrNull;
    expect(capIssue(5000), isNull);
    expect(capIssue(5001), isNotNull);
  });

  test('a file with 5 000 added clubs imports; 5 001 do not', () async {
    final ok = [
      for (var i = 0; i < 5000; i++)
        PackClub(id: _added + i, name: 'Club $i', country: 'cze'),
    ];
    final r = await PackCodec.decode(
      PackCodec.encode(_pack(addedClubs: ok), const {}),
    );
    expect(r, isA<PackDecoded>());
    expect((r as PackDecoded).pack.addedClubs.length, 5000);
    final over = await PackCodec.decode(
      PackCodec.encode(
        _pack(
          addedClubs: [
            ...ok,
            PackClub(id: _added + 5000, name: 'Club 5000', country: 'cze'),
          ],
        ),
        const {},
      ),
    );
    expect(over, isA<PackRejected>());
  });

  test('checking 5 000 clubs is linear: issues() in milliseconds', () {
    final p = _pack(
      addedClubs: _many(5000),
      clubs: {
        for (final c in ClubService.leagueClubs('cze').take(5)) c: '$c X',
      },
    );
    // Warm up (the game's club set, folded once per process).
    PackRules.issues(p);
    final sw = Stopwatch()..start();
    final issues = PackRules.issues(p);
    sw.stop();
    // ignore: avoid_print
    print('issues() over 5 000 clubs: ${sw.elapsedMilliseconds} ms');
    // The quadratic check took seconds at this size; the index takes a few
    // milliseconds. Loose, for a busy machine: 50 ms is the target.
    expect(sw.elapsedMilliseconds, lessThan(200));
    // The duplicates and game names it holds are all still found.
    expect(issues.whereType<NameClash>(), isNotEmpty);
    expect(
      issues.whereType<BadField>().where(
        (b) => b.reason == FieldReason.duplicate,
      ),
      isNotEmpty,
    );
  });

  test('the index answers exactly as the old scan did', () {
    final cze = ClubService.leagueClubs('cze');
    final eng = ClubService.leagueClubs('eng');
    final p = _pack(
      addedClubs: [
        ..._many(300),
        PackClub(id: _added + 900, name: '${cze[3]} New', country: 'cze'),
        PackClub(id: _added + 901, name: 'zagreb city', country: 'cro'),
      ],
      clubs: {cze[0]: '${cze[3]} New', cze[1]: ' ', eng[0]: 'Club 8'},
    );
    const cities = {
      'cro': ['Zagreb', 'Split'],
      'and': ['Andorra la Vella'],
    };
    final index = ClubNameIndex(p, cities);
    final names = [
      for (final c in p.addedClubs) c.name,
      ...cze,
      ...eng,
      '${cze[3]} new',
      'Zagreb City',
      'Andorra la Vella FC',
      'Nobody FC',
      'club 8',
      cze[0],
      cze[1],
      '  ${eng[2].toUpperCase()} ',
    ];
    for (final country in ['cze', 'eng', 'cro', 'and', 'zzz', 'CZE']) {
      for (final name in names) {
        for (final addedId in [null, _added + 8, _added + 900]) {
          for (final from in [null, cze[0], cze[1], eng[0]]) {
            expect(
              index.clash(name, country, addedId: addedId, renamedFrom: from),
              _naive(
                p,
                name,
                country,
                cities,
                addedId: addedId,
                renamedFrom: from,
              ),
              reason: '$name in $country, $addedId, from $from',
            );
          }
        }
      }
    }
  });

  test('a club strength out of 1 to 5 is an issue at its path', () {
    final p = _pack(
      clubStrengths: const {'Man Blue': 6, 'Man Red': 3},
      addedClubs: const [
        PackClub(id: _added, name: 'A', country: 'cze', strength: 0),
        PackClub(id: _added + 1, name: 'B', country: 'cze', strength: 5),
      ],
    );
    final bad = PackRules.issues(p).whereType<BadField>().map((b) => b.path);
    expect(
      bad,
      containsAll(['clubStrengths.Man Blue', 'addedClubs.$_added.strength']),
    );
    expect(bad, isNot(contains('clubStrengths.Man Red')));
    expect(bad, isNot(contains('addedClubs.${_added + 1}.strength')));
  });
}
