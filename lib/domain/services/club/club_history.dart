/// One unbroken spell at a club: the club, the country whose league it plays
/// in, and the first and last season the player spent there.
typedef ClubSpell = ({
  String club,
  String country,
  int fromYear,
  int toYear,
});

/// A player's club career, read off the clubs he held season by season.
///
/// Clubs are derived, never stored ([ClubService]): a player's club follows his
/// current rating, so improving earns him a move and fading costs him one. That
/// makes a career's worth of transfers already implicit in the save — this just
/// reads it back and collapses the repeated years into spells, so the card can
/// show "Man Blue · 2029–2033" rather than five identical rows.
abstract final class ClubHistory {
  /// Collapses a season-by-season club list (oldest first) into spells.
  ///
  /// A club the player LEAVES and later returns to is two spells, not one —
  /// only consecutive seasons merge. Seasons the player did not exist for are
  /// simply absent from [byYear]; a gap in the years does not split a spell,
  /// because the club either changed or it did not.
  static List<ClubSpell> spells(
    List<({int year, String club, String country})> byYear,
  ) {
    final out = <ClubSpell>[];
    for (final season in byYear) {
      if (season.club.isEmpty) continue;
      final last = out.isEmpty ? null : out.last;
      if (last != null &&
          last.club == season.club &&
          last.country == season.country) {
        out[out.length - 1] = (
          club: last.club,
          country: last.country,
          fromYear: last.fromYear,
          toYear: season.year,
        );
        continue;
      }
      out.add((
        club: season.club,
        country: season.country,
        fromYear: season.year,
        toYear: season.year,
      ));
    }
    return out;
  }
}
