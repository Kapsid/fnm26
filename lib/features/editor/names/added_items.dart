import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsor_industries.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/club_strength_picker.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Why a name cannot be an added club's ([AddedEdits.clubNameProblem]).
enum AddedNameProblem {
  /// Blank.
  empty,

  /// Past [PackRules.nameMax].
  tooLong,

  /// Characters that cannot be shown.
  badCharacters,

  /// A club of its country has it: one of its league's (under the name the
  /// database gives it), one the game names for its cities, or another
  /// added one.
  taken,

  /// A club of the game's goes by it, in any country. The database's club
  /// renames are keyed by the game's names and apply to every club of that
  /// name, so an added club under one would be renamed with it.
  gameClub,
}

/// The edits that add, change and delete the clubs, sponsors and Y
/// accounts a database adds. Each returns the pack unchanged (identical)
/// when there is nothing to do, and each delete drops the item's
/// `localized` names with it.
abstract final class AddedEdits {
  /// One past the highest added id of any kind, from [kPackAddedIdBase]; the
  /// lowest free id in the range when that runs past [kPackAddedIdMax].
  static int nextAddedId(WorldPack p) {
    final ids = _ids(p);
    var next = kPackAddedIdBase;
    for (final id in ids) {
      if (id >= next) next = id + 1;
    }
    if (next <= kPackAddedIdMax) return next;
    next = kPackAddedIdBase;
    while (ids.contains(next)) {
      next++;
    }
    return next;
  }

  static Set<int> _ids(WorldPack p) => {
    for (final c in p.addedClubs) c.id,
    for (final s in p.addedSponsors) s.id,
    for (final y in p.addedYAccounts) y.id,
  };

  /// The most items [section] can add ([PackRules]), or 0 where it adds
  /// none.
  static int maxOf(NameSection section) => switch (section) {
    NameSection.clubs => PackRules.addedClubsMax,
    NameSection.sponsors => PackRules.addedSponsorsMax,
    NameSection.yAccounts => PackRules.addedYMax,
    _ => 0,
  };

  /// Whether [p] adds as many items to [section] as it may.
  static bool isFull(NameSection section, WorldPack p) =>
      addedCount(section, p) >= maxOf(section);

  // Clubs.

  /// [p] with a club named [name] added to [country] (a FIFA code); [p]
  /// itself when it adds [PackRules.addedClubsMax] already.
  static WorldPack addClub(
    WorldPack p,
    String name,
    String country, {
    int? strength,
  }) {
    if (isFull(NameSection.clubs, p)) return p;
    return p.copyWith(
      addedClubs: [
        ...p.addedClubs,
        PackClub(
          id: nextAddedId(p),
          name: name.trim(),
          country: country.toLowerCase(),
          strength: strength,
        ),
      ],
    );
  }

  /// [p] with added club [id] at [strength] stars, or at its league's
  /// lowest (the default) when [strength] is null.
  static WorldPack setClubStrength(WorldPack p, int id, int? strength) {
    final club = p.addedClubs.where((c) => c.id == id).firstOrNull;
    if (club == null || club.strength == strength) return p;
    return p.copyWith(
      addedClubs: [
        for (final c in p.addedClubs)
          c.id == id ? c.copyWith(strength: Some(strength)) : c,
      ],
    );
  }

  /// [p] with added club [id] named [name], and every squad and pool player
  /// the database has at it moved with it.
  static WorldPack renameClub(WorldPack p, int id, String name) {
    final club = p.addedClubs.where((c) => c.id == id).firstOrNull;
    final to = name.trim();
    if (club == null || club.name == to) return p;
    return p.copyWith(
      addedClubs: [
        for (final c in p.addedClubs) c.id == id ? c.copyWith(name: to) : c,
      ],
      squads: _moved(p.squads, club, to),
      pools: _moved(p.pools, club, to),
    );
  }

  /// [p] without added club [id] and its `localized` names; the squad and
  /// pool players at it go back to Auto (the game places them).
  static WorldPack removeClub(WorldPack p, int id) {
    final club = p.addedClubs.where((c) => c.id == id).firstOrNull;
    if (club == null) return p;
    return p.copyWith(
      addedClubs: [
        for (final c in p.addedClubs)
          if (c.id != id) c,
      ],
      squads: _moved(p.squads, club, null),
      pools: _moved(p.pools, club, null),
      localized: _namesGone(p, 'addedClubs', id),
    );
  }

  /// Whether [pl] plays at [club].
  static bool playsAt(PackPlayer pl, PackClub club) =>
      pl.club == club.name && pl.clubCountry?.toLowerCase() == club.country;

  /// How many of [p]'s squad and pool players play at [club].
  static int playersAt(WorldPack p, PackClub club) => [
    ...p.squads.values,
    ...p.pools.values,
  ].fold(0, (n, list) => n + list.where((pl) => playsAt(pl, club)).length);

  /// [players] with everyone at [club] moved to club [to] of its country,
  /// or to Auto when [to] is null; [players] itself when nobody is there.
  static Map<int, List<PackPlayer>> _moved(
    Map<int, List<PackPlayer>> players,
    PackClub club,
    String? to,
  ) {
    if (!players.values.any((l) => l.any((pl) => playsAt(pl, club)))) {
      return players;
    }
    return {
      for (final e in players.entries)
        e.key: e.value.any((pl) => playsAt(pl, club))
            ? [
                for (final pl in e.value)
                  playsAt(pl, club)
                      ? SquadEdits.withClub(pl, to, club.country)
                      : pl,
              ]
            : e.value,
    };
  }

  /// What stops [name] being the name of a club the database adds to
  /// [country] ([id], when it is that club's new name), or null when
  /// nothing does. [countryCities] names a league-less country's own clubs.
  static AddedNameProblem? clubNameProblem(
    WorldPack p,
    String name,
    String country,
    Map<String, List<String>> countryCities, {
    int? id,
  }) {
    switch (PackRules.checkName(name)) {
      case FieldReason.empty:
        return AddedNameProblem.empty;
      case FieldReason.tooLong:
        return AddedNameProblem.tooLong;
      case FieldReason.badCharacters ||
          FieldReason.duplicate ||
          FieldReason.outOfRange:
        return AddedNameProblem.badCharacters;
      case null:
        break;
    }
    // The one check [PackRules.issues] makes too: the editor refuses
    // every clash as it is typed.
    return switch (PackRules.clubNameClash(
      p,
      name,
      country,
      countryCities,
      addedId: id,
    )) {
      ClubNameClash.added ||
      ClubNameClash.renamed ||
      ClubNameClash.game => AddedNameProblem.taken,
      ClubNameClash.renameKey ||
      ClubNameClash.gameElsewhere => AddedNameProblem.gameClub,
      null => null,
    };
  }

  // Sponsors.

  /// [p] with a sponsor added: [industry] is the `SponsorBrand.name` whose
  /// industry it takes, [description] '' for none. [p] itself when it adds
  /// [PackRules.addedSponsorsMax] already.
  static WorldPack addSponsor(
    WorldPack p,
    String name,
    SponsorDeal deal,
    String industry,
    String description,
  ) {
    if (isFull(NameSection.sponsors, p)) return p;
    return p.copyWith(
      addedSponsors: [
        ...p.addedSponsors,
        PackSponsor(
          id: nextAddedId(p),
          name: name.trim(),
          deal: deal,
          industry: industry,
          description: description.trim(),
        ),
      ],
    );
  }

  /// [p] with added sponsor [id] as given. A deal this build does not know
  /// stays until another is picked.
  static WorldPack editSponsor(
    WorldPack p,
    int id,
    String name,
    SponsorDeal deal,
    String industry,
    String description,
  ) {
    final s = p.addedSponsors.where((x) => x.id == id).firstOrNull;
    if (s == null) return p;
    final next = PackSponsor(
      id: id,
      name: name.trim(),
      deal: deal,
      industry: industry,
      description: description.trim(),
      unknownDeal: deal == s.deal ? s.unknownDeal : null,
    );
    if (next == s) return p;
    return p.copyWith(
      addedSponsors: [
        for (final x in p.addedSponsors) x.id == id ? next : x,
      ],
    );
  }

  /// [p] without added sponsor [id], its name and its description in every
  /// language.
  static WorldPack removeSponsor(WorldPack p, int id) {
    if (!p.addedSponsors.any((s) => s.id == id)) return p;
    return p.copyWith(
      addedSponsors: [
        for (final s in p.addedSponsors)
          if (s.id != id) s,
      ],
      localized: _namesGone(p, 'addedSponsors', id),
    );
  }

  // Y accounts.

  /// [p] with a Y account added, posting as [voice] in nation [nationId]'s
  /// feed (every nation's when null). [p] itself when it adds
  /// [PackRules.addedYMax] already.
  static WorldPack addY(
    WorldPack p,
    String name,
    YVoice voice,
    int? nationId,
  ) {
    if (isFull(NameSection.yAccounts, p)) return p;
    return p.copyWith(
      addedYAccounts: [
        ...p.addedYAccounts,
        PackYAccount(
          id: nextAddedId(p),
          name: name.trim(),
          voice: voice,
          nationId: nationId,
        ),
      ],
    );
  }

  /// [p] with added Y account [id] as given. A voice this build does not
  /// know stays until another is picked.
  static WorldPack editY(
    WorldPack p,
    int id,
    String name,
    YVoice voice,
    int? nationId,
  ) {
    final y = p.addedYAccounts.where((x) => x.id == id).firstOrNull;
    if (y == null) return p;
    final next = PackYAccount(
      id: id,
      name: name.trim(),
      voice: voice,
      nationId: nationId,
      unknownVoice: voice == y.voice ? y.unknownVoice : null,
    );
    if (next == y) return p;
    return p.copyWith(
      addedYAccounts: [
        for (final x in p.addedYAccounts) x.id == id ? next : x,
      ],
    );
  }

  /// [p] without added Y account [id] and its name in every language.
  static WorldPack removeY(WorldPack p, int id) {
    if (!p.addedYAccounts.any((y) => y.id == id)) return p;
    return p.copyWith(
      addedYAccounts: [
        for (final y in p.addedYAccounts)
          if (y.id != id) y,
      ],
      localized: _namesGone(p, 'addedYAccounts', id),
    );
  }

  /// [p]'s `localized` without the paths of added item [id] of [root].
  static Map<String, Map<String, String>> _namesGone(
    WorldPack p,
    String root,
    int id,
  ) => {
    for (final e in p.localized.entries)
      if (e.key != '$root.$id' && !e.key.startsWith('$root.$id.'))
        e.key: e.value,
  };
}

/// A deal type, as the editor names it.
String sponsorDealLabel(AppLocalizations l, SponsorDeal d) => switch (d) {
  SponsorDeal.risky => l.sponsorRiskyLabel,
  SponsorDeal.bigPayer => l.editorDealBigPayer,
  SponsorDeal.crowdPleaser => l.editorDealCrowdPleaser,
  SponsorDeal.familyFriendly => l.editorDealFamilyFriendly,
  SponsorDeal.marketing => l.editorDealMarketing,
};

/// The Y account types a database's own account can have, in the order
/// the editor offers them.
const List<YVoice> kAddedYVoices = [
  YVoice.fan,
  YVoice.pundit,
  YVoice.meme,
  YVoice.stats,
  YVoice.rival,
  YVoice.expro,
  YVoice.neutral,
];

/// A Y account type, as the editor names it.
String yVoiceLabel(AppLocalizations l, YVoice v) => switch (v) {
  YVoice.fan => l.editorYVoiceFan,
  YVoice.pundit => l.editorYVoicePundit,
  YVoice.meme => l.editorYVoiceMeme,
  YVoice.stats => l.editorYVoiceStats,
  YVoice.rival => l.editorYVoiceRival,
  YVoice.expro => l.editorYVoiceExpro,
  YVoice.neutral => l.editorYVoiceNeutral,
  _ => v.name,
};

/// How an account of type [v] posts, in a line.
String yVoiceAbout(AppLocalizations l, YVoice v) => switch (v) {
  YVoice.fan => l.editorYVoiceFanAbout,
  YVoice.pundit => l.editorYVoicePunditAbout,
  YVoice.meme => l.editorYVoiceMemeAbout,
  YVoice.stats => l.editorYVoiceStatsAbout,
  YVoice.rival => l.editorYVoiceRivalAbout,
  YVoice.expro => l.editorYVoiceExproAbout,
  YVoice.neutral => l.editorYVoiceNeutralAbout,
  _ => '',
};

/// The industries an added sponsor can take: each built-in label once, by
/// the first brand that has it (whose name is stored), and each picker-only
/// trade (whose [SponsorIndustry.id] is stored), deduped by label, in label
/// order.
List<({String brand, String label})> industryOptions(AppLocalizations l) {
  final seen = <String>{};
  return [
    for (final b in SponsorBrand.values)
      if (sponsorIndustryLabel(l, b) case final label
          when label.isNotEmpty && seen.add(label))
        (brand: b.name, label: label),
    for (final i in SponsorIndustry.values)
      if (extraIndustryLabel(l, i) case final label
          when label.isNotEmpty && seen.add(label))
        (brand: i.id, label: label),
  ]..sort((a, b) => searchFold(a.label).compareTo(searchFold(b.label)));
}

/// The label of industry [brand] (a `SponsorBrand.name` or a
/// [SponsorIndustry.id]), or '' for one this build does not know.
String industryLabel(AppLocalizations l, String brand) =>
    addedIndustryLabel(l, brand);

/// [groups] (a section's rows, as [nameGroups] has them) with the items
/// [pack] adds to [section]: an added club at the top of its country's
/// group (a group of its own for a country with no league, in name order);
/// added sponsors and Y accounts in a group of their own above the game's.
/// [world] names the countries.
List<NameGroup> withAddedRows(
  NameSection section,
  AppLocalizations l,
  List<NameGroup> groups,
  WorldPack pack,
  List<Nation> world,
) {
  String fold(Iterable<String?> parts) =>
      parts.whereType<String>().map(searchFold).join(' ');
  switch (section) {
    case NameSection.clubs:
      if (pack.addedClubs.isEmpty) return groups;
      final byCode = {for (final n in world) n.code.toLowerCase(): n};
      final added = <String, List<NameEntry>>{};
      for (final c in pack.addedClubs) {
        final n = byCode[c.country];
        (added[c.country] ??= []).add(
          NameEntry(
            key: section.addedKey(c.id),
            original: c.name,
            addedId: c.id,
            nationId: n?.id,
            clubCountry: c.country,
            fold: fold([c.name, n?.name, n?.englishName]),
          ),
        );
      }
      final out = <NameGroup>[
        for (final g in groups)
          switch (added.remove(g.flagCode?.toLowerCase())) {
            final mine? => (
              title: g.title,
              flagCode: g.flagCode,
              entries: [...mine, ...g.entries],
            ),
            null => g,
          },
      ];
      for (final e in added.entries) {
        final n = byCode[e.key];
        out.add((
          title: n?.name ?? e.key.toUpperCase(),
          flagCode: n?.code,
          entries: e.value,
        ));
      }
      return out
        ..sort((a, b) => searchFold(a.title!).compareTo(searchFold(b.title!)));
    case NameSection.sponsors || NameSection.yAccounts:
      final nations = {for (final n in world) n.id: n};
      final entries = section == NameSection.sponsors
          ? [
              for (final s in pack.addedSponsors)
                NameEntry(
                  key: section.addedKey(s.id),
                  original: s.name,
                  original2: s.description,
                  addedId: s.id,
                  detail: [
                    sponsorDealLabel(l, s.deal),
                    industryLabel(l, s.industry),
                  ].where((x) => x.isNotEmpty).join(' · '),
                  fold: fold([s.name, industryLabel(l, s.industry)]),
                ),
            ]
          : [
              for (final y in pack.addedYAccounts)
                NameEntry(
                  key: section.addedKey(y.id),
                  original: y.name,
                  addedId: y.id,
                  detail:
                      '${yVoiceLabel(l, y.voice)} · '
                      '${nations[y.nationId]?.name ?? l.editorAddedAllNations}',
                  fold: fold([y.name, nations[y.nationId]?.name]),
                ),
            ];
      if (entries.isEmpty) return groups;
      entries.sort((a, b) => a.fold.compareTo(b.fold));
      return [
        (title: l.editorAddedGroup, flagCode: null, entries: entries),
        for (final g in groups)
          (
            title: g.title ?? l.editorAddedGameGroup,
            flagCode: g.flagCode,
            entries: g.entries,
          ),
      ];
    case NameSection.stadiums ||
        NameSection.competitions ||
        NameSection.press ||
        NameSection.nameLists ||
        NameSection.managers:
      return groups;
  }
}

/// The small "Added" tag of a club the database adds.
class AddedTag extends StatelessWidget {
  const AddedTag({super.key});

  @override
  Widget build(BuildContext context) => Container(
    key: AddedItemForm.tagKey,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: AppColors.tertiary.withValues(alpha: 0.14),
      borderRadius: AppRadii.lgAll,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.add_circle_outline,
          size: 12,
          color: AppColors.tertiary,
        ),
        const SizedBox(width: 3),
        Text(
          AppLocalizations.of(context).editorAddedTag,
          style: AppTypography.labelSmall.copyWith(color: AppColors.tertiary),
        ),
      ],
    ),
  );
}

/// Adds a club, sponsor or Y account to a database ([id] null), or edits
/// and deletes one it adds.
///
/// Adding takes everything in one go, with the Add button. Editing saves as
/// it is typed, a name that cannot be used (one its country or the other
/// accounts already have, characters that cannot be shown) refused with a
/// message and not saved; everything typed in one opening is one undo step,
/// and each pick is a step of its own. An added club's new name takes the
/// database's players at it along.
class AddedItemForm extends ConsumerStatefulWidget {
  const AddedItemForm({
    required this.packId,
    required this.section,
    required this.world,
    this.id,
    this.onDone,
    this.onAdded,
    this.onDeleted,
    super.key,
  });

  static const Key nameKey = Key('editorAdded.name');
  static const Key countryKey = Key('editorAdded.country');
  static const Key industryKey = Key('editorAdded.industry');
  static const Key descriptionKey = Key('editorAdded.description');
  static const Key nationKey = Key('editorAdded.nation');
  static const Key addKey = Key('editorAdded.add');
  static const Key deleteKey = Key('editorAdded.delete');
  static const Key doneKey = Key('editorAdded.done');
  static const Key noLeagueKey = Key('editorAdded.noLeague');
  static const Key playersHereKey = Key('editorAdded.playersHere');
  static const Key fullKey = Key('editorAdded.full');
  static const Key tagKey = Key('editorAdded.tag');
  static const Key pickerSearchKey = Key('editorAdded.picker.search');

  static Key dealKey(SponsorDeal d) => Key('editorAdded.deal.${d.name}');
  static Key voiceKey(YVoice v) => Key('editorAdded.voice.${v.name}');

  /// A picker's option: a country's lower-case code, an industry's brand,
  /// a nation's id (`'all'` for every nation).
  static Key optionKey(String id) => Key('editorAdded.picker.option.$id');

  final int packId;
  final NameSection section;

  /// The nations of the database.
  final List<Nation> world;

  /// The added item edited, or null to add one.
  final int? id;

  /// Closes the form (the phone's sheet, the tablet's dialog); null shows
  /// no Done button.
  final VoidCallback? onDone;

  /// Told the id of the item just added.
  final void Function(int id)? onAdded;

  /// Told the name of the item just deleted, right after the delete (an
  /// undo snackbar goes there).
  final void Function(String name)? onDeleted;

  @override
  ConsumerState<AddedItemForm> createState() => _AddedItemFormState();
}

class _AddedItemFormState extends ConsumerState<AddedItemForm> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  String? _country;

  /// The added club's strength (null: its league's lowest).
  int? _strength;
  SponsorDeal _deal = SponsorDeal.crowdPleaser;
  String? _industry;
  YVoice _voice = YVoice.fan;
  int? _nationId;

  /// This opening's undo group for what is typed.
  Object _group = Object();

  /// The pack this form last wrote: any other (an undo) is read back in.
  WorldPack? _mine;
  bool _writing = false;

  NameSection get _section => widget.section;
  bool get _adding => widget.id == null;
  PackEditor get _editor =>
      ref.read(packEditorProvider(widget.packId).notifier);

  @override
  void initState() {
    super.initState();
    _fill(ref.read(packEditorProvider(widget.packId)).valueOrNull);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  /// The fields as [pack] has the edited item (nothing to fill when adding).
  void _fill(WorldPack? pack) {
    final id = widget.id;
    if (pack == null || id == null) return;
    switch (_section) {
      case NameSection.clubs:
        final c = pack.addedClubs.where((x) => x.id == id).firstOrNull;
        if (c == null) return;
        _set(_name, c.name);
        _country = c.country;
        _strength = c.strength;
      case NameSection.sponsors:
        final s = pack.addedSponsors.where((x) => x.id == id).firstOrNull;
        if (s == null) return;
        _set(_name, s.name);
        _set(_description, s.description);
        _deal = s.deal;
        _industry = s.industry;
      case NameSection.yAccounts:
        final y = pack.addedYAccounts.where((x) => x.id == id).firstOrNull;
        if (y == null) return;
        _set(_name, y.name);
        _voice = y.voice;
        _nationId = y.nationId;
      case _:
        return;
    }
  }

  static void _set(TextEditingController c, String text) {
    if (c.text == text) return;
    c.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Whether the edited item is in [pack].
  bool _exists(WorldPack pack) {
    final id = widget.id;
    return switch (_section) {
      NameSection.clubs => pack.addedClubs.any((x) => x.id == id),
      NameSection.sponsors => pack.addedSponsors.any((x) => x.id == id),
      NameSection.yAccounts => pack.addedYAccounts.any((x) => x.id == id),
      _ => false,
    };
  }

  /// [p] with the item as the fields have it: added, or edited.
  WorldPack _apply(WorldPack p) {
    final id = widget.id;
    final name = _name.text;
    switch (_section) {
      case NameSection.clubs:
        if (id != null) return AddedEdits.renameClub(p, id, name);
        final country = _country;
        return country == null
            ? p
            : AddedEdits.addClub(p, name, country, strength: _strength);
      case NameSection.sponsors:
        final industry = _industry;
        if (industry == null) return p;
        return id == null
            ? AddedEdits.addSponsor(p, name, _deal, industry, _description.text)
            : AddedEdits.editSponsor(
                p,
                id,
                name,
                _deal,
                industry,
                _description.text,
              );
      case NameSection.yAccounts:
        return id == null
            ? AddedEdits.addY(p, name, _voice, _nationId)
            : AddedEdits.editY(p, id, name, _voice, _nationId);
      case _:
        return p;
    }
  }

  String _countryName(String code) =>
      widget.world
          .where((n) => n.code.toLowerCase() == code)
          .firstOrNull
          ?.name ??
      code.toUpperCase();

  /// What is wrong with the name and the description as typed, in words.
  ({String? name, String? description}) _errors(
    AppLocalizations l,
    WorldPack pack,
  ) {
    final text = _name.text;
    final max = _section == NameSection.yAccounts
        ? PackRules.handleMax
        : PackRules.nameMax;
    String? name;
    if (text.trim().isEmpty) {
      name = _adding ? null : l.editorAddedNameNeeded;
    } else {
      name = switch (PackRules.checkName(text, max: max)) {
        FieldReason.tooLong => l.editorNameTooLong(max),
        FieldReason.badCharacters => l.editorNameBadCharacters,
        _ => null,
      };
    }
    if (name == null && text.trim().isNotEmpty) {
      switch (_section) {
        case NameSection.clubs:
          name = switch (AddedEdits.clubNameProblem(
            pack,
            text,
            _country ?? '',
            _editor.countryCities,
            id: widget.id,
          )) {
            AddedNameProblem.taken => l.editorAddedClubTaken(
              _countryName(_country ?? ''),
            ),
            AddedNameProblem.gameClub => l.editorAddedClubGameName,
            _ => null,
          };
        case NameSection.yAccounts:
          final next = _apply(pack);
          final id = widget.id ?? AddedEdits.nextAddedId(pack);
          if (!identical(next, pack) && PackRules.addedYNameTaken(next, id)) {
            name = l.editorNamesTaken;
          }
        case _:
          break;
      }
    }
    String? description;
    if (_section == NameSection.sponsors &&
        _description.text.trim().isNotEmpty) {
      description = switch (PackRules.checkName(
        _description.text,
        max: PackRules.descriptionMax,
      )) {
        FieldReason.tooLong => l.editorNameTooLong(PackRules.descriptionMax),
        FieldReason.badCharacters => l.editorNameBadCharacters,
        _ => null,
      };
    }
    return (name: name, description: description);
  }

  /// Whether the fields as they are make a whole item.
  bool _complete(WorldPack pack, ({String? name, String? description}) e) =>
      _name.text.trim().isNotEmpty &&
      e.name == null &&
      e.description == null &&
      switch (_section) {
        NameSection.clubs => _country != null,
        NameSection.sponsors => _industry != null,
        _ => true,
      };

  void _write(WorldPack Function(WorldPack) edit, {Object? group}) {
    _writing = true;
    try {
      _editor.update(edit, group: group);
    } finally {
      _writing = false;
    }
    _mine = ref.read(packEditorProvider(widget.packId)).valueOrNull;
  }

  /// A field changed: when editing, saved if it can be used ([typed]: as
  /// part of this opening's typing, else a step of its own).
  void _changed({bool typed = true}) {
    setState(() {});
    if (_adding) return;
    final pack = ref.read(packEditorProvider(widget.packId)).valueOrNull;
    if (pack == null) return;
    final l = AppLocalizations.of(context);
    final e = _errors(l, pack);
    if (!_complete(pack, e)) return;
    if (typed) {
      _write(_apply, group: _group);
    } else {
      _write(_apply);
      _group = Object();
    }
  }

  void _add() {
    final pack = ref.read(packEditorProvider(widget.packId)).valueOrNull;
    if (pack == null) return;
    final id = AddedEdits.nextAddedId(pack);
    final next = _apply(pack);
    if (identical(next, pack)) return;
    _write((_) => next);
    widget.onAdded?.call(id);
    widget.onDone?.call();
  }

  void _delete() {
    final id = widget.id;
    if (id == null) return;
    final name = _name.text.trim();
    _write(
      (p) => switch (_section) {
        NameSection.clubs => AddedEdits.removeClub(p, id),
        NameSection.sponsors => AddedEdits.removeSponsor(p, id),
        NameSection.yAccounts => AddedEdits.removeY(p, id),
        _ => p,
      },
    );
    widget.onDeleted?.call(name);
    widget.onDone?.call();
  }

  Future<void> _pickCountry() async {
    final l = AppLocalizations.of(context);
    final nations = [...widget.world]
      ..sort((a, b) => searchFold(a.name).compareTo(searchFold(b.name)));
    final picked = await showAddedPicker(
      context,
      title: l.editorAddedCountryPick,
      options: [
        for (final n in nations)
          (
            id: n.code.toLowerCase(),
            label: n.name,
            about: null,
            fold:
                '${searchFold(n.name)} ${searchFold(n.englishName)} '
                '${n.code.toLowerCase()}',
            flag: n.code,
          ),
      ],
      current: _country,
    );
    if (picked == null || !mounted) return;
    setState(() => _country = picked);
  }

  Future<void> _pickIndustry() async {
    final l = AppLocalizations.of(context);
    final picked = await showAddedPicker(
      context,
      title: l.editorAddedIndustryPick,
      options: [
        for (final o in industryOptions(l))
          (
            id: o.brand,
            label: o.label,
            about: null,
            fold: searchFold(o.label),
            flag: null,
          ),
      ],
      current: _industry,
    );
    if (picked == null || !mounted) return;
    _industry = picked;
    _changed(typed: false);
  }

  Future<void> _pickNation() async {
    final l = AppLocalizations.of(context);
    final nations = [...widget.world]
      ..sort((a, b) => searchFold(a.name).compareTo(searchFold(b.name)));
    final picked = await showAddedPicker(
      context,
      title: l.editorAddedPostsIn,
      options: [
        (
          id: 'all',
          label: l.editorAddedAllNations,
          about: null,
          fold: searchFold(l.editorAddedAllNations),
          flag: null,
        ),
        for (final n in nations)
          (
            id: '${n.id}',
            label: n.name,
            about: null,
            fold:
                '${searchFold(n.name)} ${searchFold(n.englishName)} '
                '${n.code.toLowerCase()}',
            flag: n.code,
          ),
      ],
      current: _nationId == null ? 'all' : '$_nationId',
    );
    if (picked == null || !mounted) return;
    _nationId = picked == 'all' ? null : int.tryParse(picked);
    _changed(typed: false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    ref.listen(packEditorProvider(widget.packId), (_, next) {
      final pack = next.valueOrNull;
      if (_adding || pack == null || _writing || identical(pack, _mine)) {
        return;
      }
      // Changed elsewhere (an undo): show what the pack now holds.
      _group = Object();
      setState(() => _fill(pack));
    });
    final pack = ref.watch(packEditorProvider(widget.packId)).valueOrNull;
    if (pack == null) return const SizedBox.shrink();
    if (!_adding && !_exists(pack)) {
      return EditorMessage(l.editorAddedGone, icon: Icons.search_off);
    }
    final errors = _errors(l, pack);
    final full = _adding && AddedEdits.isFull(_section, pack);
    final muted = AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    final fieldStyle = AppTypography.bodyLarge.copyWith(
      color: AppColors.onSurface,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(l),
        const SizedBox(height: AppSpacing.md),
        if (full) ...[
          _Note(
            key: AddedItemForm.fullKey,
            icon: Icons.block,
            color: AppColors.warning,
            text: switch (_section) {
              NameSection.clubs => l.editorAddedClubsFull(
                PackRules.addedClubsMax,
              ),
              NameSection.sponsors => l.editorAddedSponsorsFull(
                PackRules.addedSponsorsMax,
              ),
              _ => l.editorAddedYFull(PackRules.addedYMax),
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        TextField(
          key: AddedItemForm.nameKey,
          controller: _name,
          autofocus: _adding,
          maxLength: _section == NameSection.yAccounts
              ? PackRules.handleMax
              : PackRules.nameMax,
          textCapitalization: _section == NameSection.yAccounts
              ? TextCapitalization.none
              : TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: fieldStyle,
          onChanged: (_) => _changed(),
          decoration: InputDecoration(
            labelText: l.editorNameLabel,
            errorText: errors.name,
            errorMaxLines: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...switch (_section) {
          NameSection.clubs => _clubFields(l, pack, muted),
          NameSection.sponsors => _sponsorFields(l, errors, fieldStyle, muted),
          NameSection.yAccounts => _yFields(l, muted),
          _ => const <Widget>[],
        },
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (!_adding)
              OutlinedButton.icon(
                key: AddedItemForm.deleteKey,
                onPressed: _delete,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.6),
                  ),
                ),
                icon: const Icon(Icons.delete_outline),
                label: Text(l.editorAddedDelete),
              ),
            if (_adding)
              FilledButton.icon(
                key: AddedItemForm.addKey,
                onPressed: !full && _complete(pack, errors) ? _add : null,
                style: FilledButton.styleFrom(minimumSize: const Size(120, 44)),
                icon: const Icon(Icons.add),
                label: Text(l.editorAddedAdd),
              )
            else if (widget.onDone != null)
              FilledButton(
                key: AddedItemForm.doneKey,
                onPressed: widget.onDone,
                style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
                child: Text(l.editorNamesDone),
              ),
          ],
        ),
      ],
    );
  }

  Widget _header(AppLocalizations l) {
    final title = _adding
        ? switch (_section) {
            NameSection.clubs => l.editorAddClub,
            NameSection.sponsors => l.editorAddSponsor,
            _ => l.editorAddY,
          }
        : _name.text.trim();
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(switch (_section) {
            NameSection.clubs => Icons.shield_outlined,
            NameSection.sponsors => Icons.handshake_outlined,
            _ => Icons.alternate_email,
          }, color: AppColors.tertiary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleMedium,
          ),
        ),
        if (!_adding) const AddedTag(),
      ],
    );
  }

  List<Widget> _clubFields(
    AppLocalizations l,
    WorldPack pack,
    TextStyle muted,
  ) {
    final code = _country;
    final noLeague =
        code != null &&
        ClubService.leagueClubs(code).isEmpty &&
        (_editor.countryCities[code] ?? const []).isEmpty;
    final club = widget.id == null
        ? null
        : pack.addedClubs.where((c) => c.id == widget.id).firstOrNull;
    final here = club == null ? 0 : AddedEdits.playersAt(pack, club);
    final nation = code == null
        ? null
        : widget.world.where((n) => n.code.toLowerCase() == code).firstOrNull;
    return [
      _PickField(
        key: AddedItemForm.countryKey,
        label: l.editorAddedCountry,
        value: code == null ? null : _countryName(code),
        placeholder: l.editorAddedCountryPick,
        leading: code == null ? null : FlagDisc(nation?.code ?? code, size: 28),
        // A club stays in the country it was added to: its players are
        // stored there.
        onTap: _adding ? _pickCountry : null,
      ),
      if (noLeague) ...[
        const SizedBox(height: AppSpacing.sm),
        _Note(
          key: AddedItemForm.noLeagueKey,
          icon: Icons.info_outline,
          color: AppColors.warning,
          text: l.editorAddedNoLeague(_countryName(code)),
        ),
      ],
      const SizedBox(height: AppSpacing.md),
      ClubStrengthPicker(
        value: _strength,
        defaultStars: ClubService.addedDefaultStars(code ?? ''),
        onChanged: (stars) {
          final id = widget.id;
          setState(() => _strength = stars);
          if (id == null) return;
          _write((p) => AddedEdits.setClubStrength(p, id, stars));
          _group = Object();
        },
      ),
      if (here > 0) ...[
        const SizedBox(height: AppSpacing.sm),
        _Note(
          key: AddedItemForm.playersHereKey,
          icon: Icons.groups_outlined,
          color: AppColors.onSurfaceVariant,
          text: l.editorAddedClubPlayers(here),
        ),
      ],
    ];
  }

  List<Widget> _sponsorFields(
    AppLocalizations l,
    ({String? name, String? description}) errors,
    TextStyle fieldStyle,
    TextStyle muted,
  ) {
    final industry = _industry;
    return [
      Text(l.editorAddedDeal, style: AppTypography.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final d in SponsorDeal.values)
            ChoiceChip(
              key: AddedItemForm.dealKey(d),
              label: Text(sponsorDealLabel(l, d)),
              selected: _deal == d,
              onSelected: (_) {
                if (_deal == d) return;
                _deal = d;
                _changed(typed: false);
              },
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(sponsorDealLine(l, _deal), style: muted),
      const SizedBox(height: AppSpacing.md),
      _PickField(
        key: AddedItemForm.industryKey,
        label: l.editorAddedIndustry,
        value: industry == null ? null : industryLabel(l, industry),
        placeholder: l.editorAddedIndustryPick,
        leading: const Icon(Icons.factory_outlined),
        onTap: _pickIndustry,
      ),
      const SizedBox(height: AppSpacing.md),
      TextField(
        key: AddedItemForm.descriptionKey,
        controller: _description,
        minLines: 2,
        maxLines: 4,
        maxLength: PackRules.descriptionMax,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        style: fieldStyle,
        onChanged: (_) => _changed(),
        decoration: InputDecoration(
          labelText: l.editorAddedDescription,
          alignLabelWithHint: true,
          hintText: sponsorDealLine(l, _deal),
          hintMaxLines: 3,
          helperText: l.editorAddedDescriptionHelp,
          helperMaxLines: 2,
          errorText: errors.description,
          errorMaxLines: 2,
        ),
      ),
    ];
  }

  List<Widget> _yFields(AppLocalizations l, TextStyle muted) {
    final nation = widget.world.where((n) => n.id == _nationId).firstOrNull;
    return [
      Text(l.editorAddedVoice, style: AppTypography.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final v in kAddedYVoices)
            ChoiceChip(
              key: AddedItemForm.voiceKey(v),
              label: Text(yVoiceLabel(l, v)),
              selected: _voice == v,
              onSelected: (_) {
                if (_voice == v) return;
                _voice = v;
                _changed(typed: false);
              },
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(yVoiceAbout(l, _voice), style: muted),
      const SizedBox(height: AppSpacing.md),
      _PickField(
        key: AddedItemForm.nationKey,
        label: l.editorAddedPostsIn,
        value: nation?.name ?? l.editorAddedAllNations,
        placeholder: l.editorAddedAllNations,
        leading: nation == null
            ? const Icon(Icons.public)
            : FlagDisc(nation.code, size: 28),
        onTap: _pickNation,
      ),
    ];
  }
}

/// A line of note with its icon, in [color].
class _Note extends StatelessWidget {
  const _Note({
    required this.icon,
    required this.color,
    required this.text,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.sm),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.10),
      borderRadius: AppRadii.lgAll,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurface),
          ),
        ),
      ],
    ),
  );
}

/// A field that opens a picker: its label, and the value picked (else
/// [placeholder]). Null [onTap] shows it fixed.
class _PickField extends StatelessWidget {
  const _PickField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.leading,
    super.key,
  });

  final String label;
  final String? value;
  final String placeholder;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: AppRadii.lgAll,
    child: InputDecorator(
      isEmpty: false,
      decoration: InputDecoration(
        labelText: label,
        enabled: onTap != null || value != null,
        suffixIcon: onTap == null ? null : const Icon(Icons.expand_more),
      ),
      child: Row(
        children: [
          if (leading case final w?) ...[
            w,
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              value ?? placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyLarge.copyWith(
                color: value == null
                    ? AppColors.onSurfaceVariant
                    : AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// One choice of [showAddedPicker]: its [id], what it reads, an optional
/// line under it, what the search matches (folded) and a flag to show.
typedef AddedOption = ({
  String id,
  String label,
  String? about,
  String fold,
  String? flag,
});

/// Asks for one of [options], with a search: a sheet on the phone, a
/// dialog on a tablet. Returns the picked id, or null.
Future<String?> showAddedPicker(
  BuildContext context, {
  required String title,
  required List<AddedOption> options,
  String? current,
}) => showAdaptiveSheet<String>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) =>
      _AddedPicker(title: title, options: options, current: current),
);

class _AddedPicker extends StatefulWidget {
  const _AddedPicker({
    required this.title,
    required this.options,
    required this.current,
  });

  final String title;
  final List<AddedOption> options;
  final String? current;

  @override
  State<_AddedPicker> createState() => _AddedPickerState();
}

class _AddedPickerState extends State<_AddedPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final q = searchFold(_query);
    final shown = [
      for (final o in widget.options)
        if (q.isEmpty || o.fold.contains(q)) o,
    ];
    final height = MediaQuery.sizeOf(context).height * 0.7;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: height.clamp(320, 640),
        width: 480,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(widget.title, style: AppTypography.titleMedium),
              ),
              TextField(
                key: AddedItemForm.pickerSearchKey,
                onChanged: (v) => setState(() => _query = v),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: l.editorAddedSearch,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: shown.isEmpty
                    ? EditorMessage(l.editorNamesNone, icon: Icons.search_off)
                    : ListView.builder(
                        itemCount: shown.length,
                        itemBuilder: (context, i) {
                          final o = shown[i];
                          return ListTile(
                            key: AddedItemForm.optionKey(o.id),
                            leading: o.flag == null
                                ? null
                                : FlagDisc(o.flag!, size: 28),
                            title: Text(
                              o.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: o.about == null ? null : Text(o.about!),
                            trailing: o.id == widget.current
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.primary,
                                  )
                                : null,
                            onTap: () => Navigator.of(context).pop(o.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens [AddedItemForm] to add an item to [section] (a sheet on the phone,
/// a dialog on a tablet); [onAdded] is told the new item's id.
Future<void> showAddedItemSheet(
  BuildContext context, {
  required int packId,
  required NameSection section,
  required List<Nation> world,
  void Function(int id)? onAdded,
}) => showAdaptiveSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (sheet) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheet).bottom),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.sm,
        AppSpacing.marginMobile,
        AppSpacing.lg,
      ),
      child: AddedItemForm(
        packId: packId,
        section: section,
        world: world,
        onAdded: onAdded,
        onDone: () => Navigator.of(sheet).pop(),
      ),
    ),
  ),
);
