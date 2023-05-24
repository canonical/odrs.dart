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
