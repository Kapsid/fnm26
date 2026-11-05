import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/nation_label.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/l10n/app_localizations.dart';

const _spain = 50;
const _france = 18;

const _spainRow = NationRow(
  id: _spain,
  name: 'Spain',
  code: 'ESP',
  confederation: Confederation.europe,
  ranking: 3,
  isFreeDemo: false,
  primaryColor: '#C60B1E',
  secondaryColor: '#FFC400',
);

const _franceRow = NationRow(
  id: _france,
  name: 'France',
  code: 'FRA',
  confederation: Confederation.europe,
  ranking: 2,
  isFreeDemo: false,
  primaryColor: '#002395',
  secondaryColor: '#FFFFFF',
);

AppLocalizations _l(String code) => lookupAppLocalizations(Locale(code));

const _pack = WorldPack(
  uuid: 'u',
  name: 'Burgers',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  nations: {_spain: (name: 'Burgerland', code: 'BGL')},
  competitions: {
    'European Championship': 'Euro Burger',
    'World Championship': 'Burger Cup',
    'Nations Cup': 'Patty League',
  },
  sponsors: {'Acme': 'Grill Co'},
  stadiums: {'$_spain:Madrid': 'Bun Arena'},
  reporters: {2: PackReporter(name: 'Ann Bun', outlet: 'Grill Post')},
  yAccounts: {'@fan': '@griller'},
  trophies: {'wc'},
);

final _world = ActiveWorld(
  _pack,
  trophies: {
    'wc': Uint8List.fromList([1, 2, 3]),
  },
  realCodes: const {_spain: 'ESP', _france: 'FRA'},
);

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  group('ActiveWorld', () {
    test('answers every override the pack holds, and null otherwise', () {
      expect(_world.isDefault, isFalse);
      expect(_world.nationName(_spain), 'Burgerland');
      expect(_world.nationCode(_spain), 'BGL');
      expect(_world.nationName(_france), isNull);
      expect(_world.nationCode(_france), isNull);
      expect(_world.codeLabel('ESP'), 'BGL');
      expect(_world.codeLabel('FRA'), isNull);
      expect(_world.competition('European Championship'), 'Euro Burger');
      expect(_world.competition('South America Cup'), isNull);
      expect(_world.sponsor('Acme'), 'Grill Co');
      expect(_world.sponsor('Other'), isNull);
      expect(_world.stadium(_spain, 'Madrid'), 'Bun Arena');
      expect(_world.stadium(_spain, 'Seville'), isNull);
      expect(_world.reporter(2)?.outlet, 'Grill Post');
      expect(_world.reporter(3), isNull);
      expect(_world.yAccount('@fan'), '@griller');
      expect(_world.yAccount('@x'), isNull);
      expect(_world.trophy('wc'), [1, 2, 3]);
      expect(_world.trophy('euro'), isNull);
    });

    test('the default world overrides nothing', () {
      const w = ActiveWorld.none;
      expect(w.isDefault, isTrue);
      expect(w.nationName(_spain), isNull);
      expect(w.nationCode(_spain), isNull);
      expect(w.codeLabel('ESP'), isNull);
      expect(w.competition('European Championship'), isNull);
      expect(w.sponsor('Acme'), isNull);
      expect(w.stadium(_spain, 'Madrid'), isNull);
      expect(w.reporter(2), isNull);
      expect(w.yAccount('@fan'), isNull);
      expect(w.trophy('wc'), isNull);
    });

    test('the stored aliases of the World Championship follow its rename', () {
      for (final alias in [
        'World Championship',
        'World Cup',
        'the World Cup',
        'World Championship Finals',
      ]) {
        expect(_world.competition(alias), 'Burger Cup', reason: alias);
      }
    });
  });

  group('nations', () {
    test('renamed nation shows the new name in every language', () {
      for (final lang in ['en', 'cs', 'ja']) {
        final n = _spainRow.toDomain(languageCode: lang, world: _world);
        expect(n.name, 'Burgerland', reason: lang);
        // Logic resolving by name and every key on the code stay real.
        expect(n.englishName, 'Spain');
        expect(n.code, 'ESP');
        expect(n.displayCode, 'BGL');
        expect(n.shortCode, 'BGL');
      }
    });

    test('an untouched nation keeps its translation and code', () {
      final cs = _franceRow.toDomain(languageCode: 'cs', world: _world);
      expect(cs.name, _franceRow.toDomain(languageCode: 'cs').name);
      expect(cs.name, isNot('France'));
      expect(cs.displayCode, '');
      expect(cs.shortCode, 'FRA');
    });

    test('without a world the mapper is exactly as before', () {
      final n = _spainRow.toDomain(languageCode: 'cs');
      expect(n.name, isNot('Burgerland'));
      expect(n.shortCode, 'ESP');
      expect(
        n,
        const Nation(
          id: _spain,
          name: 'Španělsko',
          code: 'ESP',
          confederation: Confederation.europe,
          ranking: 3,
          primaryColor: '#C60B1E',
          secondaryColor: '#FFC400',
          englishName: 'Spain',
        ),
      );
    });

    test('a renamed nation is not declined from its old Czech name', () {
      ActiveWorld.current = _world;
      final n = _spainRow.toDomain(languageCode: 'cs', world: _world);
      expect(nationAgainst(_l('cs'), n, '?'), 'Burgerland');
    });

    test('a printed code follows the world', () {
      expect(nationCodeLabel('ESP'), 'ESP');
      ActiveWorld.current = _world;
      expect(nationCodeLabel('ESP'), 'BGL');
      expect(nationCodeLabel('FRA'), 'FRA');
    });
  });

  group('competitions', () {
    test('renamed European Championship shows in its label and in its '
        'Qualifiers label, in every language', () {
      ActiveWorld.current = _world;
      for (final lang in ['en', 'cs', 'ja']) {
        final l = _l(lang);
        expect(competitionLabel(l, 'European Championship'), 'Euro Burger');
        expect(
          continentalCupLabel(l, Confederation.europe),
          'Euro Burger',
          reason: lang,
        );
        expect(
          competitionLabel(l, 'European Championship Qualifiers'),
          l.compQualifiers('Euro Burger'),
          reason: lang,
        );
      }
    });

    test('the World Championship rename reaches its qualifying names', () {
      ActiveWorld.current = _world;
      final l = _l('cs');
      expect(competitionLabel(l, 'World Championship'), 'Burger Cup');
      expect(competitionLabel(l, 'World Cup'), 'Burger Cup');
      for (final stored in [
        'World Cup Qualifiers',
        'World Cup Qualifying',
        'World Championship Qualifiers',
      ]) {
        expect(
          competitionLabel(l, stored),
          l.compQualifiers('Burger Cup'),
          reason: stored,
        );
      }
      expect(competitionLabel(l, 'Nations Cup'), 'Patty League');
    });

    test('untouched competitions keep their translations', () {
      ActiveWorld.current = _world;
      final l = _l('cs');
      expect(competitionLabel(l, 'South America Cup'), l.compSouthAmericaCup);
      expect(
        continentalCupLabel(l, Confederation.asia),
        l.compAsianChampionship,
      );
      expect(
        competitionLabel(l, 'Europe Qualifiers'),
        l.compQualifiers(l.confEurope),
      );
    });

    test('default world: labels unchanged', () {
      final l = _l('cs');
      expect(
        competitionLabel(l, 'European Championship'),
        isNot('Euro Burger'),
      );
      expect(
        competitionLabel(l, 'European Championship'),
        l.compEuropeanChampionship,
      );
      expect(
        competitionLabel(l, 'World Cup Qualifiers'),
        l.compWorldCupQualifying,
      );
    });
  });
}
