import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The placements on My Career ("Champions", "Did not qualify") are kept in
/// canonical English by the career summary, which compares and quotes them.
/// The tournament history printed them raw, so a Czech manager read
/// "World Championship 2042 ... Did not qualify". This walks the page in
/// other languages and fails on any of the English words, in any case: the
/// app writes plates in capitals and an earlier guard was blind to them.
const List<String> _english = [
  'did not qualify',
  'champions',
  'runners-up',
  'third place',
  'quarter-finals',
  'round of 16',
  'group stage',
];

/// Every string drawn on screen, scrolling each list to its end so a lazy
/// row is built at least once.
Future<List<String>> _allText(WidgetTester tester) async {
  final seen = <String>[];
  void look() {
    for (final t in tester.widgetList<Text>(find.byType(Text))) {
      seen.add(t.data ?? t.textSpan?.toPlainText() ?? '');
    }
    for (final r in tester.widgetList<RichText>(find.byType(RichText))) {
      seen.add(r.text.toPlainText());
    }
  }

  look();
  for (final s in tester.stateList<ScrollableState>(find.byType(Scrollable))) {
    final p = s.position;
    if (p.axis != Axis.vertical) continue;
    while (p.pixels < p.maxScrollExtent) {
      p.jumpTo((p.pixels + 200).clamp(0, p.maxScrollExtent));
      await tester.pump();
      look();
    }
  }
  return seen;
}

void main() {
  for (final (code, form, size) in [
    ('cs', FormFactor.phone, kPhoneSize),
    ('cs', FormFactor.tablet, kTabletSize),
    ('de', FormFactor.phone, kPhoneSize),
  ]) {
    testWidgets('My Career speaks $code: no English placement (${form.name})', (
      tester,
    ) async {
      final l = lookupAppLocalizations(Locale(code));
      final save = await seedSave(
        tester,
        formFactor: form,
        overrides: [fakeCareerSummaryOverride()],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.careerSummary}?careerId=${save.careerId}',
        size: size,
        locale: Locale(code),
      );
      expect(tester.takeException(), isNull);
      final text = await _allText(tester);
      for (final s in text) {
        final lower = s.trim().toLowerCase();
        // Anywhere for the phrase the owner met; whole-label for the rest,
        // since a fixture's made-up cup ("Intercontinental Champions
        // Challenge Trophy") is a name and passes through untranslated.
        expect(lower, isNot(contains(_english.first)), reason: '"$s"');
        expect(_english, isNot(contains(lower)), reason: '"$s" on My Career');
      }
      // And the missed tournament is still said, in the manager's language.
      expect(
        text.any((s) => s.contains(l.finishDidNotQualify)),
        isTrue,
        reason: 'the missed World Championship row is gone',
      );
      await tester.pumpWidget(const SizedBox());
    });
  }
}
