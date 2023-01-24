import 'package:odrs/odrs.dart';
import 'package:test/test.dart';

void main() {
  test('to/from json', () {
    const json = {
      'star0': 1,
      'star1': 2,
      'star2': 3,
      'star3': 4,
      'star4': 5,
      'star5': 6,
      'total': 21,
    };

    final rating = OdrsRating(
      star0: 1,
      star1: 2,
      star2: 3,
      star3: 4,
      star4: 5,
      star5: 6,
      total: 21,
    );

    expect(rating.toJson(), equals(json));
    expect(OdrsRating.fromJson(json), equals(rating));
  });
}
