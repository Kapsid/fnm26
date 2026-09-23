import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Every date the manager reads, written in the manager's own language.
///
/// ## Why this is one place and not twelve
///
/// Twelve screens each built their own `DateFormat('d MMM yyyy')` with no
/// locale, and `intl` answers a locale-less `DateFormat` with whatever
/// `Intl.defaultLocale` says — which nothing in this app ever sets, so it is
/// `en_US` on every phone on earth. All twelve were wrong together, and a
/// thirteenth would have been wrong the same way. They now all come through
/// here, the way every honour-year comparison comes through
/// `CareerService.isOwnHonourYear`.
///
/// ## Where the Czech month names come from
///
/// Nothing in this file loads locale data and nothing needs to:
/// `GlobalMaterialLocalizations.delegate` — already in
/// `AppLocalizations.localizationsDelegates`, and so already on the root
/// `MaterialApp` and on every `pumpApp` in the tests — calls
/// `loadDateIntlDataIfNotLoaded()` when it loads, and that registers the date
/// symbols and patterns for EVERY locale flutter_localizations ships, Czech
/// included. So `DateFormat(pattern, 'cs')` has had its data since the first
/// frame; the only thing that was ever missing was the `'cs'`.
///
/// That also means these helpers need a `BuildContext` under a `Localizations`
/// — which every call site has, and which is what makes them follow the
/// language the manager picked rather than the one the phone is set to.
///
/// ## Why the patterns are not in the .arb files
///
/// A pattern is not copy. The words in a date — `zář`, `út` — come from CLDR
/// via flutter_localizations, not from our strings; all an .arb entry would
/// carry is the field order and a full stop, in a syntax where one stray
/// letter silently reformats every date in the game and no translator would
/// see it coming. The two languages sit side by side here instead, where the
/// width consequences of changing one are visible next to the other.
abstract final class AppDate {
  /// The language the widget tree is being drawn in, as `intl` names it.
  ///
  /// Anything that is not Czech is English: those are the two languages the
  /// app speaks, and `supportedLocales` has already resolved the phone's
  /// Portuguese down to one of them by the time this is asked.
  static String _locale(BuildContext context) =>
      Localizations.maybeLocaleOf(context)?.languageCode == 'cs' ? 'cs' : 'en';

  /// Formats [date] with whichever of the two patterns the language wants.
  ///
  /// Czech writes the day of the month as an ordinal, so it takes a full stop:
  /// `1. zář 2030`, never `1 zář 2030`. That full stop is the whole difference
  /// between the two patterns everywhere below, and it is also a character of
  /// extra width in a mono font — see the width tests.
  static String _write(
    BuildContext context,
    DateTime date, {
    required String en,
    required String cs,
  }) {
    final locale = _locale(context);
    return DateFormat(locale == 'cs' ? cs : en, locale).format(date);
  }

  /// `Sep 2030` / `zář 2030` — a month, for a save tile or a career summary.
  static String monthYear(BuildContext context, DateTime date) =>
      _write(context, date, en: 'MMM yyyy', cs: 'MMM yyyy');

  /// `1 Sep` / `1. zář` — a fixture's day, where the year is already known.
  static String dayMonth(BuildContext context, DateTime date) =>
      _write(context, date, en: 'd MMM', cs: 'd. MMM');

  /// `1 Sep 2030` / `1. zář 2030` — a full date. The dashboard's, among others.
  static String dayMonthYear(BuildContext context, DateTime date) =>
      _write(context, date, en: 'd MMM yyyy', cs: 'd. MMM yyyy');

  /// `1 Sep 30` / `1. zář 30` — a full date squeezed into a narrow column.
  static String dayMonthShortYear(BuildContext context, DateTime date) =>
      _write(context, date, en: 'd MMM yy', cs: 'd. MMM yy');

  /// `WED 12 JUN` / `ST 12. ČVN` — the next match's kick-off stamp.
  ///
  /// Upper case because both call sites are set as a label, and `toUpperCase`
  /// is safe on Czech: the abbreviations it has to raise are `po út st čt pá
  /// so ne` and `led úno bře dub kvě čvn čvc srp zář říj lis pro`, all of them
  /// Latin Extended-A characters that Dart's Unicode mapping raises to the
  /// accented capital (`č` → `Č`, `ř` → `Ř`, `ú` → `Ú`) rather than stripping
  /// the diacritic. A capital with a háček is ordinary Czech typography; the
  /// width tests hold the result to its line.
  static String weekdayDayMonthCaps(BuildContext context, DateTime date) =>
      _write(context, date, en: 'EEE d MMM', cs: 'EEE d. MMM').toUpperCase();

  /// `09/30` — a tick label on the ranking chart's x-axis.
  ///
  /// The only format here that takes no context, because it is the only one
  /// with no words in it: two digits, a slash, two digits, identical in every
  /// language. It is also drawn inside a `CustomPainter.paint`, which has no
  /// `BuildContext` to ask. Czech's own numeric month-year is `M/y` — it would
  /// drop the leading zero and unpick the even spacing the axis is laid out
  /// on, for no gain to a reader who can already read it. It stays here rather
  /// than back in the painter so that the painter, too, gets its dates from
  /// the one place.
  static String monthYearNumeric(DateTime date) =>
      DateFormat('MM/yy').format(date);
}
