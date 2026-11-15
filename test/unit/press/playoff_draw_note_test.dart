import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/playoff_draw_note.dart';

void main() {
  test('a play-off draw note reads back its day, opponent and competition', () {
    final key = PlayoffDrawNote.key(
      date: DateTime(2029, 11, 20),
      opponentId: 42,
      competition: 'World Championship',
    );
    final n = PlayoffDrawNote.decode(key)!;
    expect(n.date, DateTime(2029, 11, 20));
    expect(n.opponentId, 42);
    expect(n.competition, 'World Championship');
    expect(PlayoffDrawNote.decode('calendar2'), isNull);
    expect(PlayoffDrawNote.decode('ypo:x:1:A'), isNull);
  });
}
