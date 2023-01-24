import 'package:odrs/odrs.dart';

import 'utils.dart';

Future<void> main() async {
  final client = createOdrsClient(url: 'https://odrs.gnome.org/');

  print('Please wait. Fetching all ratings...');
  final ratings = await client.getRatings();
  for (final rating in ratings.entries) {
    print('${rating.key}: ${rating.value.average.toStringAsFixed(1)}');
  }

  client.close();
}

extension OdrsRatingX on OdrsRating {
  double get average {
    return (star1 + 2 * star2 + 3 * star3 + 4 * star4 + 5 * star5) / total;
  }
}
