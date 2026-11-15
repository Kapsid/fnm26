import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';

/// A new ground is built to the size the manager picks, and costs what that
/// size costs; an order from before the choice reads as it always did.
void main() {
  test('a sized build round-trips through its marker', () {
    const w = StadiumWork.build(
      nationId: 7,
      cycle: 2,
      city: 'Ghent',
      seats: 12000,
    );
    final kind = w.encode();
    expect(kind, 'stadiumBuild2:7:2:12000:Ghent');
    final back = StadiumWork.decode(kind)!;
    expect(back.isBuild, isTrue);
    expect(back.capacity, 12000);
    expect(back.stadium.city, 'Ghent');
    expect(back.cycle, 2);
  });

  test('an old build marker still reads, at the usual new size', () {
    final back = StadiumWork.decode('stadiumBuild:7:2:Ghent')!;
    expect(back.isBuild, isTrue);
    expect(back.capacity, 0);
    expect(
      const StadiumWork.build(nationId: 7, cycle: 2, city: 'Ghent').encode(),
      'stadiumBuild:7:2:Ghent',
    );
  });

  test('the price follows the seats, small grounds cheap', () {
    expect(NationalStadiums.buildCostFor(5000), 8000000);
    expect(NationalStadiums.buildCostFor(65000), 36000000);
    expect(
      NationalStadiums.buildCostFor(10000),
      lessThan(NationalStadiums.buildCostFor(30000)),
    );
    expect(NationalStadiums.buildSeats(1000), NationalStadiums.minBuildSeats);
    expect(NationalStadiums.buildSeats(123456), NationalStadiums.maxBuildSeats);
    expect(NationalStadiums.buildSeats(12345), 12000);
  });
}
