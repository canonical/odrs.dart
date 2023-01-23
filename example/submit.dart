import 'utils.dart';

Future<void> main(List<String> args) async {
  if (args.length != 2 || int.tryParse(args.last) == null) {
    print('Usage: submit <app-id> <stars>');
    print('For example: submit inkscape.desktop 5');
    return;
  }

  final client = createOdrsClient(
    app: 'odrs_example',
    url: 'https://odrs-dev.apps.openshift4.gnome.org/',
  );

  final appId = args.first;
  final stars = int.parse(args.last);

  final before = await client.getRating(appId);
  print('Rating before: $before');

  print('Submitting $stars stars...');
  await client.submitReview(
    appId: appId,
    rating: (stars / 5 * 100).round(),
    version: '0', // required
    userDisplay: 'Somebody', // required
    summary: '...', // required (2-70 characters)
    description: '...', // required (2-3000 characters)
  );

  final after = await client.getRating(appId);
  print('Rating after: $after');

  client.close();
}
