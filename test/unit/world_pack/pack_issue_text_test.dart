import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

const int _f = PoolGenerator.firstFringeId;
const int _a = kPackAddedIdBase;

PackPlayer _p(int id, {List<PlayerTrait>? traits, int age = 25}) => PackPlayer(
  id: id,
  name: 'Pool $id',
  age: age,
  position: PlayerPosition.cm,
  attributes: const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
  potential: 90,
  traits: traits,
);

void main() {
  final l = AppLocalizationsEn();

  test('every format 2 issue is said in words and opens its section', () {
    final league = ClubService.leagueClubs('cze').first;
    final pack = WorldPack(
      uuid: 'u',
      name: 'n',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
      pools: {
        1: [
          _p(_f, age: 50),
          _p(_f + 1, traits: PlayerTrait.values.take(5).toList()),
          _p(5),
          _p(_f),
        ],
        2: [for (var i = 0; i < 151; i++) _p(_f + 100 + i)],
        999: const [],
      },
      addedClubs: [
        PackClub(id: 1, name: league, country: 'cze'),
        const PackClub(id: _a, name: 'Zed FC', country: 'zzz'),
      ],
      addedSponsors: [
        PackSponsor(
          id: _a,
          name: 'Brand',
          deal: SponsorDeal.values.first,
          industry: 'gone',
          description: 'd' * 121,
        ),
      ],
      addedYAccounts: const [
        PackYAccount(
          id: _a + 1,
          name: 'TheOldStopper',
          voice: YVoice.fan,
          nationId: 999,
        ),
      ],
      localized: {
        'competitions.Old Cup': {'cs': 'Pohár'},
        'clubs.Old FC': {'xx': 'Klub', 'cs': ''},
        'addedClubs.700000099': {'cs': 'Klub'},
        'nations.1': {'cs': 'X'},
      },
    );
    final issues = [
      ...PackRules.compatibility(
        pack,
        nationIds: {1, 2},
        competitionNames: {'World Championship'},
        trophyKeys: const {},
        sponsorBrands: {for (final b in SponsorBrand.values) b.name},
        yAccounts: YFeed.namedAccounts.toSet(),
        countryCodes: {'cze'},
        fringeRanges: {1: (first: _f, last: _f + 79)},
      ),
      ...PackRules.issues(pack),
      ...PackRules.unknownLanguages(pack),
    ];
    final roots = {for (final i in issues) i.where.split('.').first};
    expect(
      roots,
      containsAll([
        'pools',
        'addedClubs',
        'addedSponsors',
        'addedYAccounts',
        'localized',
      ]),
    );
    final said = {
      for (final i in issues) i.where: describePackIssue(l, i, pack, const {}),
    };
    for (final e in said.entries) {
      expect(e.value.detail, isNotEmpty, reason: e.key);
      expect(e.value.title, isNotEmpty, reason: e.key);
    }
    expect(said['pools.1.$_f.age']!.detail, l.editorIssueAge('Pool $_f'));
    expect(said['pools.1.$_f.age']!.nationId, 1);
    expect(said['pools.1.$_f.age']!.section, EditorSection.players);
    expect(said['pools.1.${_f + 1}.traits']!.detail, l.editorIssueValue);
    expect(said['pools.1.5']!.detail, l.editorIssueValue);
    expect(said['pools.2']!.detail, l.editorIssuePlayersOver(1));
    expect(said['pools.999']!.detail, l.editorIssueUnknownEntry('#999'));
    expect(said['addedClubs.1']!.detail, l.editorIssueNameTaken(league));
    expect(said['addedClubs.1']!.section, EditorSection.clubs);
    expect(said['addedClubs.1.id']!.detail, l.editorIssueValue);
    expect(said['addedClubs.$_a']!.detail, l.editorIssueUnknownEntry('Zed FC'));
    expect(
      said['addedSponsors.$_a.description']!.detail,
      l.editorIssueNameTooLong('d' * 121),
    );
    expect(said['addedSponsors.$_a']!.section, EditorSection.sponsors);
    expect(
      said['addedYAccounts.${_a + 1}']!.section,
      EditorSection.yAccounts,
    );
    expect(
      said['localized.competitions.Old Cup']!.section,
      EditorSection.competitions,
    );
    expect(
      said['localized.competitions.Old Cup']!.detail,
      l.editorIssueUnknownEntry('Old Cup'),
    );
    // A language this build does not speak is a note, said by its code.
    expect(
      said['localized.clubs.Old FC.xx']!.detail,
      l.editorIssueUnknownEntry('xx'),
    );
    expect(said['localized.clubs.Old FC.xx']!.section, EditorSection.clubs);
    expect(said['localized.clubs.Old FC.cs']!.section, EditorSection.clubs);
    expect(said['localized.addedClubs.700000099']!.detail, l.editorIssueValue);
  });

  test('the localized cap is the whole database, opening no section', () {
    final pack = WorldPack(
      uuid: 'u',
      name: 'My World',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
    );
    final t = describePackIssue(
      l,
      const BadField('localized', FieldReason.outOfRange),
      pack,
      const {},
    );
    expect(t.section, isNull);
    expect(t.title, 'My World');
    expect(t.detail, l.editorIssueValue);
  });

  test("an unknown trait, deal or voice names its player or item", () {
    final pack = WorldPack(
      uuid: 'u',
      name: 'n',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
      squads: {
        1: [_p(7)],
      },
      addedSponsors: const [
        PackSponsor(
          id: _a,
          name: 'Brand',
          deal: PackSponsor.fallbackDeal,
          industry: 'acme',
          unknownDeal: 'barter',
        ),
      ],
    );
    String said(String path) =>
        describePackIssue(l, UnknownId(path), pack, const {}).detail;
    expect(said('squads.1.7.traits'), l.editorIssueUnknownEntry('Pool 7'));
    expect(said('addedSponsors.$_a.deal'), l.editorIssueUnknownEntry('Brand'));
  });

  test('a day-one manager\'s problems open the Managers section on the '
      'nation', () {
    final pack = WorldPack(
      uuid: 'u',
      name: 'Mine',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
      managers: {
        1: (name: 'A' * 41, nationality: 'ZZZ'),
        99: (name: 'Ota Brnak', nationality: 'CZE'),
      },
    );
    final issues = [
      ...PackRules.issues(pack, baseCodes: const {1: 'CZE'}),
      ...PackRules.compatibility(
        pack,
        nationIds: {1},
        competitionNames: const {},
        trophyKeys: const {},
        sponsorBrands: const {},
        yAccounts: const {},
        countryCodes: {'cze'},
        fringeRanges: const {},
      ),
    ];
    final world = {
      for (final n in [
        const Nation(
          id: 1,
          name: 'Czechia',
          code: 'CZE',
          confederation: Confederation.europe,
          ranking: 40,
        ),
      ])
        n.id: n,
    };
    final said = {
      for (final i in issues) i.where: describePackIssue(l, i, pack, world),
    };
    final name = said['managers.1.name']!;
    expect(name.detail, l.editorIssueManagerName(PackRules.nameMax));
    expect(name.title, 'Czechia');
    expect(name.section, EditorSection.managers);
    expect(name.nationId, 1);
    final nationality = said['managers.1.nationality']!;
    expect(nationality.detail, l.editorIssueManagerNationality);
    expect(nationality.section, EditorSection.managers);
    // An unknown nation is removed by Remove.
    expect(said['managers.99']!.section, EditorSection.managers);
    expect(
      PackEditor.dropUnknown(pack, 'managers.99').managers.keys,
      [1],
    );
  });
}
