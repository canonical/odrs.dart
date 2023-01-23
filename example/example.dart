import 'package:odrs/odrs.dart';
import 'utils.dart';

Future<void> main() async {
  final client = OdrsClient(
    url: Uri.parse('https://odrs-dev.apps.openshift4.gnome.org/'),
    userHash: getUserHash(salt: 'my_app'),
    distro: getDistroName(),
  );

  print('Fetching all ratings...');
  final ratings = await client.getRatings();
  print('-> ${ratings.length} ratings');

  const appId = '0ad.desktop';
  // const appId = 'org.gnome.gedit.desktop';
  // const appId = 'supertuxkart.desktop';

  print('Fetching rating for $appId...');
  final rating = await client.getRating(appId);
  print('-> $rating');

  print('Submitting review for $appId...');
  await client.submitReview(
    appId: appId,
    rating: 5,
    version: '0', // required
    userDisplay: 'Me', // required
    summary: 'Max 70 characters', // required
    description: 'Max 3000 characters', // required
  );

  final after = await client.getRating(appId);
  print('-> $after');

  client.close();
}
