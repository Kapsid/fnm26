import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/federation/sponsor_industries.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/world_pack/pack_keys.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/names/added_items.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

WorldPack _pack(List<PackSponsor> s) => WorldPack(
  uuid: 'u',
  name: 'P',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  addedSponsors: s,
);

PackSponsor _sponsor(String industry) => PackSponsor(
  id: kPackAddedIdBase,
  name: 'Acme',
  deal: SponsorDeal.risky,
  industry: industry,
);

void main() {
  final l = AppLocalizationsEn();
  final keys = PackGameKeys.of(
    const [],
    codes: const {},
    fringeRanges: const {},
  );

  test('the picker-only industries never collide with a brand name', () {
    final brands = {for (final b in SponsorBrand.values) b.name};
    final ids = [for (final i in SponsorIndustry.values) i.id];
    expect(ids.toSet().length, ids.length);
    expect(ids.where(brands.contains), isEmpty);
    expect(ids.length, greaterThanOrEqualTo(25));
    for (final i in SponsorIndustry.values) {
      expect(SponsorIndustry.byId(i.id), i);
    }
  });

  test('options list the new industries once, sorted, with labels', () {
    final o = industryOptions(l);
    final labels = [for (final x in o) x.label];
    expect(labels.toSet().length, labels.length, reason: 'deduped');
    for (final i in SponsorIndustry.values) {
      final label = extraIndustryLabel(l, i);
      expect(label, isNotEmpty);
      expect(o.any((x) => x.brand == i.id && x.label == label), isTrue);
      expect(industryLabel(l, i.id), label);
    }
    // The built-in ones are still offered, by brand name.
    expect(o.any((x) => x.brand == SponsorBrand.agrofart.name), isTrue);
    expect(
      industryLabel(l, SponsorBrand.agrofart.name),
      'Farming and chemicals',
    );
    final sorted = [...labels]
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    expect(labels.length, sorted.length);
  });

  test('an unknown industry still reads as nothing', () {
    expect(industryLabel(l, 'indNoSuchTrade'), '');
    expect(industryLabel(l, 'nothing'), '');
    expect(industryLabel(l, ''), '');
  });

  test('an added sponsor with a new industry round-trips and is accepted', () {
    final s = _sponsor(SponsorIndustry.sportswear.id);
    final back = PackSponsor.fromJson(
      jsonDecode(jsonEncode(s.toJson())),
    );
    expect(back, s);
    expect(back.industry, 'indSportswear');
    final p = _pack([s]);
    // Not malformed, and not flagged as something this build lacks.
    expect(
      PackRules.issues(p).where((i) => i.where.contains('industry')),
      isEmpty,
    );
    expect(keys.check(p), isEmpty);
  });

  test('an unknown industry is flagged as before', () {
    final p = _pack([_sponsor('indNoSuchTrade')]);
    expect(
      [for (final i in keys.check(p)) i.where],
      ['addedSponsors.$kPackAddedIdBase'],
    );
  });
}
