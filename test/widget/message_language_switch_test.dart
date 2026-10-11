import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// The point of the whole thing: a message is translated when it is READ.
///
/// "Některé zprávy jsou taky anglicky… Není to tím, že přišly, když jsem měl
/// přepnuto na EN?" — it was. The inbox stored the SENTENCE, written with
/// whatever `AppLocalizations` the app happened to hold when the news was
/// filed, so a message that arrived in English stayed English for ever.
///
/// These tests file news in one language and read it in the other. With the
/// fix reverted (a message stored as words) the first two fail on the Czech
/// they never find.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late CompetitionRepository comp;
  const careerId = 1;

  setUp(() async {
    db = createTestDatabase();
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    comp = container.read(competitionRepositoryProvider);
    await container
        .read(careerRepositoryProvider)
        .create(
          managerName: 'M',
          nationId: 1,
          rngSeed: 1,
          startDate: DateTime(2026, 9),
        );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<MessageItem> single() async => (await comp.messages(careerId)).single;

  /// A world-ranking release, the message he named: a headline, and a body
  /// built out of two nested phrases.
  Future<void> fileRankingNews(AppLocalizations wroteIn) => comp.addTextMessage(
    l: wroteIn,
    careerId: careerId,
    dedupKey: 'rankrel:2030',
    category: 'ranking',
    title: const MsgText(MsgKey.msgRankTitle, [7]),
    body: const MsgText(MsgKey.msgRankBody, [
      MsgText(MsgKey.msgRankLeadYou),
      MsgText(MsgKey.msgRankUp1, [3, 7]),
    ]),
    year: 2030,
  );

  testWidgets('news filed in English reads in Czech after the switch', (
    tester,
  ) async {
    await fileRankingNews(AppLocalizationsEn());
    final message = await single();

    // What the columns hold is English — it was filed in English, and a reader
    // that knows nothing of specs still has a sentence.
    expect(message.title, AppLocalizationsEn().msgRankTitle(7));

    await tester.pumpApp(
      Scaffold(body: MessageSheet(message: message)),
      locale: const Locale('cs'),
    );

    final cs = AppLocalizationsCs();
    expect(find.text(cs.msgRankTitle(7)), findsOneWidget);
    expect(
      find.text(
        cs.msgRankBody(cs.msgRankLeadYou, cs.msgRankUp1(3, 7)),
      ),
      findsOneWidget,
      reason: 'the body was written in the language it happened in',
    );
    expect(find.text(AppLocalizationsEn().msgRankTitle(7)), findsNothing);
  });

  testWidgets('and news filed in Czech reads in English', (tester) async {
    // The switch the other way round, which is the one a manager playing in
    // Czech actually makes when he shows the game to somebody.
    await fileRankingNews(AppLocalizationsCs());
    final message = await single();

    await tester.pumpApp(
      Scaffold(body: MessageSheet(message: message)),
      locale: const Locale('en'),
    );

    final en = AppLocalizationsEn();
    expect(find.text(en.msgRankTitle(7)), findsOneWidget);
    expect(
      find.text(en.msgRankBody(en.msgRankLeadYou, en.msgRankUp1(3, 7))),
      findsOneWidget,
    );
  });

  testWidgets('a message filed before this keeps the words it was filed in', (
    tester,
  ) async {
    // The save on his phone right now: rows with a rendered title and body and
    // no spec at all. They are shown exactly as they were written, which is
    // the only honest thing a dated archive with nothing else can do.
    await comp.addMessage(
      careerId: careerId,
      dedupKey: 'old:1',
      category: 'ranking',
      title: 'World ranking: #7',
      body: 'You hold seventh.',
      year: 2029,
    );
    final message = await single();
    expect(message.spec, isNull);

    await tester.pumpApp(
      Scaffold(body: MessageSheet(message: message)),
      locale: const Locale('cs'),
    );

    expect(find.text('World ranking: #7'), findsOneWidget);
    expect(find.text('You hold seventh.'), findsOneWidget);
  });

  testWidgets('an encoded report keeps its table and translates its note', (
    tester,
  ) async {
    // A body that is a REPORT is stored as it comes — the sheet lays it out
    // itself — but the line above it is meaning like any other, so the academy
    // note follows the language even though the table does not.
    const note = MsgText(MsgKey.msgIntakeNoteAcademy);
    await comp.addTextMessage(
      l: AppLocalizationsEn(),
      careerId: careerId,
      dedupKey: 'intake:1',
      category: 'youth',
      title: const MsgText(MsgKey.msgIntakeTitle, [2027]),
      rawBody: encodeSquadDevReport(const [
        SquadDevRow(
          name: 'Novák',
          age: 11,
          position: 'ST',
          rating: 54,
          status: SquadDevStatus.arrived,
          stars: 4,
        ),
      ], note: AppLocalizationsEn().msgIntakeNoteAcademy),
      note: note,
      year: 2027,
    );

    await tester.pumpApp(
      Scaffold(body: MessageSheet(message: await single())),
      locale: const Locale('cs'),
    );

    final cs = AppLocalizationsCs();
    expect(find.text(cs.msgIntakeTitle(2027)), findsOneWidget);
    expect(find.text(cs.msgIntakeNoteAcademy), findsOneWidget);
    expect(find.text('Novák'), findsOneWidget, reason: 'the table survived');
  });

  /// The board's end-of-cycle verdict: new copy, and the longest of it — an
  /// outstanding cycle with a World Championship named in it AND the national
  /// hero's sentence joined on the end.
  Future<void> fileBoardVerdict(AppLocalizations wroteIn) =>
      comp.addTextMessage(
        l: wroteIn,
        careerId: careerId,
        dedupKey: 'board:0',
        category: 'board',
        title: const MsgText(MsgKey.boardVerdictDelightedTitle),
        body: const MsgJoin([
          MsgText(MsgKey.boardVerdictDelightedBody, [
            88,
            MsgText(MsgKey.boardVerdictBestWorld, [
              MsgText(MsgKey.finishChampions),
            ]),
          ]),
          MsgText(MsgKey.boardVerdictHeroNote, ['Czechia', 3]),
        ]),
        year: 2030,
      );

  testWidgets("the board's verdict is read in the manager's language", (
    tester,
  ) async {
    await fileBoardVerdict(AppLocalizationsEn());

    await tester.pumpApp(
      Scaffold(body: MessageSheet(message: await single())),
      locale: const Locale('cs'),
    );

    final cs = AppLocalizationsCs();
    expect(find.text(cs.boardVerdictDelightedTitle), findsOneWidget);
    expect(
      find.text(
        cs.boardVerdictDelightedBody(
              88,
              cs.boardVerdictBestWorld(cs.finishChampions),
            ) +
            cs.boardVerdictHeroNote('Czechia', 3),
      ),
      findsOneWidget,
    );
  });

  for (final width in const [320.0, 360.0, 400.0]) {
    for (final locale in const ['en', 'cs']) {
      testWidgets("the board's verdict fits $locale at ${width.toInt()}", (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await fileBoardVerdict(AppLocalizationsEn());

        await tester.pumpApp(
          Scaffold(
            body: SingleChildScrollView(
              child: MessageSheet(message: await single()),
            ),
          ),
          locale: Locale(locale),
        );

        expectNothingCut(tester, "the board's verdict at ${width.toInt()}");
      });

      testWidgets('a ranking message fits $locale at ${width.toInt()}', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await fileRankingNews(AppLocalizationsEn());

        await tester.pumpApp(
          Scaffold(body: MessageSheet(message: await single())),
          locale: Locale(locale),
        );

        expectNothingCut(tester, 'the message sheet at ${width.toInt()}');
      });
    }
  }
}
