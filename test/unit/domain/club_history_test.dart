import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/club/club_history.dart';

void main() {
  ({int year, String club, String country}) season(
    int year,
    String club, [
    String country = 'eng',
  ]) =>
      (year: year, club: club, country: country);

  group('ClubHistory.spells', () {
    test('collapses consecutive seasons at one club into a spell', () {
      final spells = ClubHistory.spells([
        season(2026, 'Man Blue'),
        season(2027, 'Man Blue'),
        season(2028, 'Man Blue'),
      ]);
      expect(spells.length, 1);
      expect(spells.single.club, 'Man Blue');
      expect(spells.single.fromYear, 2026);
      expect(spells.single.toYear, 2028);
    });

    test('a move starts a new spell', () {
      final spells = ClubHistory.spells([
        season(2026, 'Prague Reds', 'cze'),
        season(2027, 'Prague Reds', 'cze'),
        season(2028, 'Madrid White', 'esp'),
      ]);
      expect(spells.length, 2);
      expect(spells.first.toYear, 2027);
      expect(spells.last.club, 'Madrid White');
      expect(spells.last.country, 'esp');
      expect(spells.last.fromYear, 2028);
    });

    test('returning to a former club is a second spell, not one long one', () {
      final spells = ClubHistory.spells([
        season(2026, 'Man Blue'),
        season(2027, 'Madrid White', 'esp'),
        season(2028, 'Man Blue'),
      ]);
      expect(spells.length, 3);
      expect(spells.first.fromYear, 2026);
      expect(spells.first.toYear, 2026);
      expect(spells.last.fromYear, 2028);
    });

    test('the same club name in a different league is a move', () {
      final spells = ClubHistory.spells([
        season(2026, 'City', 'eng'),
        season(2027, 'City', 'usa'),
      ]);
      expect(spells.length, 2);
    });

    test('seasons with no club are skipped, and an empty career is empty', () {
      expect(ClubHistory.spells(const []), isEmpty);
      final spells = ClubHistory.spells([
        season(2026, ''),
        season(2027, 'Man Blue'),
      ]);
      expect(spells.length, 1);
      expect(spells.single.fromYear, 2027);
    });
  });
}
