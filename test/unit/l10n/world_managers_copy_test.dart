import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The world-managers copy is in every language.
///
/// Every key the feature added exists in all 28 ARBs, and outside English none
/// is left as the English text. A few strings are rightly the same word in a
/// language (a loanword, a bare placeholder pair); those are listed by
/// language below rather than waived everywhere.
void main() {
  final dir = Directory('lib/l10n');
  Map<String, dynamic> arb(String code) =>
      jsonDecode(File('${dir.path}/app_$code.arb').readAsStringSync())
          as Map<String, dynamic>;

  const keys = [
    'hostBidBelowBar',
    'mgrNewsSacked',
    'mgrNewsResigned',
    'mgrNewsPoached',
    'mgrNewsRetired',
    'mgrNewsContractEnd',
    'mgrNewsReplacedByPlayer',
    'mgrNewsAppointed',
    'mgrNewsAppointedBody',
    'pressBeatOpposingManager',
    'pressAnswerHitBackAtManager',
    'pressAnswerRespectManager',
    'yMgrTie1',
    'yMgrTie2',
    'yMgrTie3',
    'yMgrTie4',
    'mgrRowLabel',
    'mgrRowDetail',
    'mgrRecordWdl',
    'mgrRowRecord',
    'mgrTieNeutral',
    'mgrTieRespect',
    'mgrTieRival',
    'mgrTieGrudge',
    'mgrTieSuccessor',
    'mgrTieProtege',
    'mgrTieFormerPlayer',
    'mgrEndSacked',
    'mgrEndResigned',
    'mgrEndPoached',
    'mgrEndRetired',
    'mgrEndContractEnd',
    'mgrEndReplacedByPlayer',
    'mgrProfileSpells',
    'mgrProfileSpellNow',
    'mgrProfileSpellRange',
    'mgrProfileSpellEnded',
    'mgrProfileRecordVsYou',
    'mgrProfileNoMeetings',
    'mgrProfileReputation',
    'mgrProfileAge',
    'mgrProfileAppointed',
    'mgrProfileStyle',
    'mgrProfileTie',
    'mgrPreviewLine',
    'mgrDossierStyle',
    'mgrDossierRecord',
    'mgrStylePossession',
    'mgrStyleHighPress',
    'mgrStyleDefensive',
    'mgrStyleDirect',
    'mgrStyleCounter',
    'mgrStyleFlair',
    'mgrStylePhysical',
    'mgrStyleBalanced',
    'mgrListTitle',
    'mgrListCurrent',
    'mgrListRecentMoves',
    'mgrListFilterAll',
    'mgrListSortReputation',
    'mgrListSortName',
    'mgrListEmptyMoves',
    'mgrListEmptyCurrent',
    'saveUpgradeFailedTitle',
    'saveUpgradeFailedBody',
    'editorSectionManagers',
    'editorManagersHint',
    'editorManagerName',
    'editorManagerNationality',
    'editorIssueManagerName',
    'editorIssueManagerNationality',
  ];

  /// Key -> languages where the English word is also the right word there.
  const sameAsEnglish = <String, Set<String>>{
    'mgrTieRival': {'cs', 'fr', 'es', 'pt', 'id', 'sv', 'nb', 'da', 'hr', 'ro'},
    'mgrStylePossession': {'fr', 'fil'},
    'mgrStyleDirect': {'fr', 'nl', 'ro'},
    'mgrProfileStyle': {'fr'},
    'mgrListSortName': {'de'},
    'mgrRowLabel': {'fil'},
    // Just two placeholders and a comma.
    'mgrProfileSpellEnded': {
      'cs',
      'fr',
      'it',
      'pl',
      'es',
      'de',
      'pt',
      'tr',
      'nl',
      'id',
      'el',
      'sv',
      'nb',
      'vi',
      'bg',
      'da',
      'fi',
      'hu',
      'hr',
      'uk',
      'fil',
      'hi',
      'ko',
      'ro',
      'ms',
    },
  };

  final en = arb('en');
  final codes = [
    for (final f in dir.listSync())
      if (f.path.endsWith('.arb'))
        f.uri.pathSegments.last.replaceAll('app_', '').replaceAll('.arb', ''),
  ]..remove('en');

  test('there are 28 languages and every key is in English', () {
    expect(codes.length + 1, 28);
    expect([
      for (final k in keys)
        if (en[k] == null) k,
    ], isEmpty);
  });

  for (final code in codes) {
    test('$code has every world-managers string, translated', () {
      final t = arb(code);
      final missing = [
        for (final k in keys)
          if ((t[k] as String?)?.trim().isEmpty ?? true) k,
      ];
      expect(missing, isEmpty, reason: '$code is missing $missing');
      final same = [
        for (final k in keys)
          if (t[k] == en[k] && !(sameAsEnglish[k]?.contains(code) ?? false)) k,
      ];
      expect(same, isEmpty, reason: '$code left English on $same');
    });
  }

  test('no em dash and no World Cup in the new copy', () {
    final bad = <String>[];
    for (final code in ['en', ...codes]) {
      final t = arb(code);
      for (final k in keys) {
        final v = (t[k] as String?) ?? '';
        if (v.contains('\u2014') || v.contains('World Cup'))
          bad.add('$code.$k');
      }
    }
    expect(bad, isEmpty);
  });
}
