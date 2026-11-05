/// A nation's name pool: the first names and surnames its generated people
/// are drawn from.
typedef NamePool = ({List<String> first, List<String> sur});

/// The pool a nation's new players are named from in a career created now:
/// its classic lists (`country_names.json`: `first`, `sur`, `surLate`) with
/// its extras (`country_names_more.json`: `firstMore`, `surMore`) added,
/// each name once, classic names first in their own order.
///
/// The one place this union is made. The player repository draws from it,
/// and the editor shows it as a nation's game name lists, which a custom
/// world's lists replace whole (for players, local fans and staff); were the
/// two to differ, one edit in the editor would silently drop names.
NamePool currentNamePool({
  required List<String> first,
  List<String> firstMore = const [],
  required List<String> sur,
  List<String> surLate = const [],
  List<String> surMore = const [],
}) => (
  first: {...first, ...firstMore}.toList(),
  sur: {...sur, ...surLate, ...surMore}.toList(),
);
