import 'utils.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    print('Usage: reviews <app-id>');
    print('For example: reviews inkscape.desktop');
    return;
  }

  final client = createOdrsClient(url: 'https://odrs.gnome.org/');

  print('Please wait. Fetching reviews...');
  final reviews = await client.getReviews(appId: args.single, version: '0');
  for (final review in reviews) {
    print(review);
  }

  client.close();
}
