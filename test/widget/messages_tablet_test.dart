import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/features/messages/messages_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  for (final size in [kTabletSize, const Size(1080, 810)]) {
    testWidgets(
      'list left, the open message right; a tap opens another '
      '(${size.width.toInt()})',
      (tester) async {
        final save = await seedSave(tester, formFactor: FormFactor.tablet);
        late List<MessageItem> messages;
        await tester.runAsync(() async {
          // A new save holds one message; file two more so there is a choice.
          final repo = save.container.read(competitionRepositoryProvider);
          await repo.addMessage(
            careerId: save.careerId,
            dedupKey: 't11-draw',
            category: 'draw',
            title: 'The draw is made',
            body: 'Groups are set.',
            year: 2027,
          );
          await repo.addMessage(
            careerId: save.careerId,
            dedupKey: 't11-award',
            category: 'award',
            title: 'A player wins an award',
            body: 'Well deserved.',
            year: 2027,
          );
          save.container.invalidate(messageInboxProvider(save.careerId));
          messages = (await save.container.read(
            messageInboxProvider(save.careerId).future,
          )).messages;
        });
        expect(messages.length, greaterThanOrEqualTo(3));

        await pumpRoute(
          tester,
          save,
          '${Routes.messages}?careerId=${save.careerId}',
          size: size,
        );
        expect(tester.takeException(), isNull);
        expect(find.byKey(MessagesScreen.tabletLayoutKey), findsOneWidget);
        expect(find.byType(MasterDetail), findsOneWidget);
        // The newest is open by default.
        final first = readMessage(enL, messages.first).title;
        expect(
          find.descendant(
            of: find.byType(MessageSheet),
            matching: find.text(first),
          ),
          findsOneWidget,
        );

        final second = messages[1];
        await tester.tap(find.byKey(ValueKey('inbox.row.${second.id}')));
        await settle(tester);
        expect(
          find.descendant(
            of: find.byType(MessageSheet),
            matching: find.text(readMessage(enL, second).title),
          ),
          findsOneWidget,
        );

        // A filter keeps only its own group in the list.
        // The chip, not the sidebar's COMPETITIONS heading.
        await tester.tap(
          find.descendant(
            of: find.byType(ChoiceChip),
            matching: find.text(enL.sideGroupCompetitions.toUpperCase()),
          ),
        );
        await settle(tester);
        for (final m in messages) {
          final row = find.byKey(ValueKey('inbox.row.${m.id}'));
          expect(
            row.evaluate().isNotEmpty,
            inboxGroupOf(m.category) == InboxFilter.competitions,
            reason: '${m.category} ${m.id}',
          );
        }
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
