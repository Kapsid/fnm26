import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/press/press_copy.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Players, 1.1.0: "During the press conference, usually the last question,
/// the press asks about a player but the name is left out. 'If  is not at his
/// best, does the side have anything?' Responses all do not have the
/// player's name." A player question must never be asked without a name,
/// and no rendered press line may carry a hole where a name belonged.

const _best = 7;
const _worst = 8;
const _key = 9;
const _backed = 10;

PressStatement _statement(StatementKind kind, StatementStatus status) => (
  id: 1,
  cycle: 0,
  nationId: 1,
  kind: kind,
  playerId:
      kind == StatementKind.backPlayer || kind == StatementKind.blamePlayer
      ? _backed
      : null,
  madeOn: DateTime(2026, 3, 1),
  madeAfterFixtureId: 1,
  status: status,
  judgedOn: DateTime(2026, 6, 1),
  thrownBack: false,
  target: null,
);

ConferenceFacts _facts(
  ConferenceReason reason, {
  PressStatement? throwback,
}) => (
  reason: reason,
  bestPlayerId: reason == ConferenceReason.preview ? null : _best,
  worstPlayerId: reason == ConferenceReason.preview ? null : _worst,
  hasOpenWinNext: false,
  hasOpenJob: false,
  playersWithOpenStatement: const <int>{},
  throwback: reason == ConferenceReason.preview ? null : throwback,
  preview: reason == ConferenceReason.preview
      ? (
          campaign: PreviewCampaign.worldFinals,
          brief: 4,
          rivalNationId: 30,
          keyPlayerId: _key,
        )
      : null,
  opposingManager: null,
);

PendingConference _pending(ConferenceFacts f, int credibility) => (
  row: (
    id: 1,
    cycle: 0,
    reason: f.reason,
    fixtureId: 1,
    triggeredOn: DateTime(2026, 6, 1),
    status: ConferenceStatus.pending,
  ),
  facts: f,
  credibility: credibility,
  opponentNationId: 2,
);

/// Every beat [f] can put to him, in any order the answers can take.
List<Beat> _allBeats(ConferenceFacts f) {
  if (f.reason == ConferenceReason.preview) {
    return ConferenceBuilder.previewBeats(f);
  }
  final opening = ConferenceBuilder.opening(f);
  return [
    opening,
    for (final a in opening.answers) ConferenceBuilder.reaction(f, a),
    ?ConferenceBuilder.throwback(f),
  ];
}

/// Every set of facts worth rendering: each reason, and each throwback.
List<ConferenceFacts> _allFacts() => [
  for (final r in ConferenceReason.values) _facts(r),
  for (final kind in StatementKind.values)
    if (kind != StatementKind.target)
      for (final status in const [StatementStatus.kept, StatementStatus.broken])
        _facts(ConferenceReason.bigLoss, throwback: _statement(kind, status)),
];

bool _beatNamesPlayer(Beat b, ConferenceFacts f) => switch (b.kind) {
  BeatKind.standout || BeatKind.struggler || BeatKind.keyPlayer => true,
  BeatKind.throwback =>
    f.throwback!.kind == StatementKind.backPlayer ||
        f.throwback!.kind == StatementKind.blamePlayer,
  _ => false,
};

bool _answerNamesPlayer(AnswerKind a) =>
    a == AnswerKind.backPlayer || a == AnswerKind.blamePlayer;

/// A line with a gap in it: a double space, a space before punctuation that
/// a missing name leaves behind, or a placeholder that was never filled.
void _expectWhole(String text, String where) {
  expect(text.trim(), isNotEmpty, reason: '$where: empty');
  expect(text.contains('  '), isFalse, reason: '$where: double space: $text');
  expect(
    RegExp(r'\{\w+\}').hasMatch(text),
    isFalse,
    reason: '$where: unfilled placeholder: $text',
  );
}

void main() {
  // Unusual shapes on purpose: a hyphenated double surname, a mononym.
  const names = ['Krzysztofowicz-Wiśniewski', 'Novák', 'Neymarzinho'];

  for (final locale in AppLocalizations.supportedLocales) {
    final code = locale.toLanguageTag();
    final full = code == 'en' || code == 'cs';
    test('$code: every press line with a player slot names him', () async {
      final l = await AppLocalizations.delegate.load(locale);
      // English and Czech over many seeds; the rest over a few, which still
      // reaches every wording (a seed picks one of two to six).
      final seeds = full ? 24 : 6;
      for (final name in names) {
        final playerNames = {
          _best: name,
          _worst: name,
          _key: name,
          _backed: name,
        };
        for (final f in _allFacts()) {
          for (final credibility in const [20, 50, 80]) {
            final c = _pending(f, credibility);
            for (final beat in _allBeats(f)) {
              final player = beat.playerId == null
                  ? null
                  : playerNames[beat.playerId];
              if (beat.playerId != null) expect(player, isNotNull);
              for (var seed = 0; seed < seeds; seed++) {
                final where = '${f.reason} ${beat.kind} c$credibility s$seed';
                final q = beatQuestion(
                  l,
                  beat,
                  c,
                  playerName: player,
                  opponentName: 'Brazil',
                  seed: seed,
                  competitionName: 'World Championship',
                  rivalName: 'Argentina',
                );
                _expectWhole(q, where);
                if (_beatNamesPlayer(beat, f)) {
                  expect(q, contains(name), reason: '$where: $q');
                }
                for (final a in beat.answers) {
                  final text = answerLabel(
                    l,
                    a,
                    playerName: player,
                    seed: seed,
                  );
                  _expectWhole(text, '$where ${a.name}');
                  final note = onRecordLine(
                    l,
                    a,
                    playerName: player,
                    aim: 'Reach the semi-finals',
                  );
                  if (note != null) _expectWhole(note, '$where ${a.name} note');
                  if (_answerNamesPlayer(a)) {
                    expect(text, contains(name), reason: '$where ${a.name}');
                    expect(note, contains(name), reason: '$where ${a.name}');
                  }
                }
              }
            }
          }
        }
      }
    });
  }

  group('a player nobody can name is never asked about', () {
    test('the preview drops its key-man question', () {
      final f = ConferenceBuilder.namedOnly(
        _facts(ConferenceReason.preview),
        const {},
      );
      final beats = ConferenceBuilder.previewBeats(f);
      expect(beats.map((b) => b.kind), isNot(contains(BeatKind.keyPlayer)));
    });

    test('a blank name counts as no name', () {
      final f = ConferenceBuilder.namedOnly(_facts(ConferenceReason.preview), {
        _key: '  ',
      });
      expect(f.preview!.keyPlayerId, isNull);
    });

    test('after a match, the reaction asks a follow-up instead', () {
      for (final reason in ConferenceReason.values) {
        if (reason == ConferenceReason.preview) continue;
        final f = ConferenceBuilder.namedOnly(_facts(reason), const {});
        for (final beat in _allBeats(f)) {
          expect(beat.playerId, isNull, reason: '$reason ${beat.kind}');
          expect(
            beat.answers.where(_answerNamesPlayer),
            isEmpty,
            reason: '$reason ${beat.kind}',
          );
        }
      }
    });

    test('a throwback about an unnamed man is not thrown back', () {
      for (final kind in const [
        StatementKind.backPlayer,
        StatementKind.blamePlayer,
      ]) {
        final f = ConferenceBuilder.namedOnly(
          _facts(
            ConferenceReason.bigLoss,
            throwback: _statement(kind, StatementStatus.kept),
          ),
          {_best: 'Novák', _worst: 'Novák'},
        );
        expect(ConferenceBuilder.throwback(f), isNull);
      }
      // One that names nobody stays.
      final f = ConferenceBuilder.namedOnly(
        _facts(
          ConferenceReason.bigLoss,
          throwback: _statement(StatementKind.winNext, StatementStatus.kept),
        ),
        const {},
      );
      expect(ConferenceBuilder.throwback(f), isNotNull);
    });

    test('named players are kept', () {
      final all = {_best: 'A', _worst: 'B', _key: 'C', _backed: 'D'};
      final f = ConferenceBuilder.namedOnly(
        _facts(
          ConferenceReason.bigLoss,
          throwback: _statement(StatementKind.backPlayer, StatementStatus.kept),
        ),
        all,
      );
      expect(f.bestPlayerId, _best);
      expect(f.worstPlayerId, _worst);
      expect(f.throwback, isNotNull);
      final p = ConferenceBuilder.namedOnly(
        _facts(ConferenceReason.preview),
        all,
      );
      expect(p.preview!.keyPlayerId, _key);
    });
  });
}
