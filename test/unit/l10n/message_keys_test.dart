import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// Every string a stored message can be made of, in BOTH languages.
///
/// A message is stored as a [MsgKey] plus its arguments and written when it is
/// read, so a key with nothing behind it in one locale is a message that
/// renders as a blank line in that language — and nobody would find it, because
/// the inbox is the one screen a test never walks end to end. This walks it:
/// every value of the enum, in English and in Czech.
///
/// It also pins the round trip through the database. A spec goes into the save
/// as JSON and comes back out cycles later, possibly into a build that has
/// moved on; what it must never do is come back as something else.
void main() {
  final locales = <String, AppLocalizations>{
    'en': AppLocalizationsEn(),
    'cs': AppLocalizationsCs(),
  };

  // Enough arguments for the widest string, and ints — which read as a number
  // wherever a String is expected and as themselves where a count is. The
  // words are not under test here; having any at all is.
  const args = [7, 7, 7, 7, 7, 7];

  test('every message key is written in both languages', () {
    for (final entry in locales.entries) {
      for (final key in MsgKey.values) {
        final text = renderMsgKey(entry.value, MsgText(key, args));
        expect(
          text.trim(),
          isNotEmpty,
          reason: '$key has no ${entry.key} wording',
        );
        expect(
          text,
          isNot(contains('{')),
          reason: '$key left a placeholder unfilled in ${entry.key}',
        );
      }
    }
  });

  test('a spec survives the round trip through the database', () {
    const spec = MsgJoin([
      MsgText(MsgKey.msgRetireBodyWith, [
        'Novák',
        MsgJoin([
          MsgText(MsgKey.msgTallyCaps, [82]),
          MsgText(MsgKey.msgTallyGoals, [31]),
        ], separator: ', '),
        35,
      ]),
      MsgText(MsgKey.msgArmbandVacant),
    ]);
    final l = locales['cs']!;

    final decoded = decodeMessageSpec(
      encodeMessageSpec(title: const MsgText(MsgKey.msgWpotyTitle), body: spec),
    );

    expect(decoded, isNotNull);
    expect(renderMsgPart(l, decoded!.body!), renderMsgPart(l, spec));
    expect(renderMsgPart(l, decoded.title), l.msgWpotyTitle);
    expect(decoded.note, isNull);
  });

  test("a competition inside a message is named in the reader's language", () {
    // Competition names are STORED in English and compared all over the app, so
    // a message carries the stored name and it goes through competitionLabel
    // when it is read, exactly as on every screen.
    const spec = MsgText(MsgKey.msgChampTitleMine1, [
      MsgComp('World Championship'),
    ]);
    expect(
      renderMsgPart(locales['cs']!, spec),
      isNot(contains('World Championship')),
    );
    expect(
      renderMsgPart(locales['en']!, spec),
      contains(locales['en']!.compWorldCup),
    );
  });

  test('a stage reads lower case where the copy needs it', () {
    const spec = MsgLower(MsgText(MsgKey.finishQuarterFinals));
    for (final l in locales.values) {
      final text = renderMsgPart(l, spec);
      expect(text, text.toLowerCase());
      expect(text.trim(), isNotEmpty);
    }
  });

  test('a spec this build cannot read falls back rather than throwing', () {
    // The forward-compatibility promise: a key removed in a later build, a
    // truncated column, a row written by something else. None of them may
    // cost the manager the message — he gets the words it was filed with.
    for (final broken in const [
      '{"t":{"k":"aKeyThatNoLongerExists"}}',
      '{"t":{"k":"msgRankTitle","a":[7]},"b":{"k":"nope"}}',
      'not json at all',
      '{"b":{"k":"msgRankLeadYou"}}',
      '',
    ]) {
      final decoded = decodeMessageSpec(broken);
      expect(
        decoded?.body,
        isNull,
        reason: '"$broken" resolved to something it should not have',
      );
    }
    expect(decodeMessageSpec(null), isNull);
  });

  test('nothing files a message as words', () {
    // The regression this batch exists to prevent: addMessage stores the
    // SENTENCE, so a caller that reaches for it directly hands the manager a
    // message frozen in whatever language the app happened to be in. Everything
    // that files news goes through addTextMessage, which stores the meaning
    // beside the words. Only the repository itself may name addMessage.
    final offenders = <String>[];
    for (final file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      if (file.path.endsWith('competition_repository.dart') ||
          file.path.endsWith('drift_competition_repository.dart') ||
          file.path.endsWith('message_text.dart')) {
        continue;
      }
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].contains('addMessage(')) {
          offenders.add('${file.path}:${i + 1}');
        }
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'these file a message as rendered words, so it can never be read in '
          'another language:\n  ${offenders.join('\n  ')}\n'
          'Use addTextMessage with a MsgText instead (see '
          'lib/core/util/message_text.dart).',
    );
  });
}
