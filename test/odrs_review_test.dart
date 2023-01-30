import 'package:odrs/odrs.dart';
import 'package:test/test.dart';

void main() {
  test('to/from json', () {
    const json = {
      'app_id': 'foo.bar.baz',
      'date_created': 1674596178.0,
      'description': 'This is a description',
      'distro': 'Ubuntu',
      'karma_down': 0,
      'karma_up': 0,
      'locale': 'en_US.UTF-8',
      'rating': 80,
      'reported': 0,
      'review_id': 123456,
      'summary': 'This is a summary',
      'user_display': 'Somebody',
      'user_hash': '123456',
      'user_skey': 'abcdef',
      'version': '1.2.3'
    };

    final review = OdrsReview(
      appId: 'foo.bar.baz',
      dateCreated: DateTime.fromMillisecondsSinceEpoch(1674596178 * 1000),
      description: 'This is a description',
      distro: 'Ubuntu',
      karmaDown: 0,
      karmaUp: 0,
      locale: 'en_US.UTF-8',
      rating: 80,
      reported: 0,
      reviewId: 123456,
      summary: 'This is a summary',
      userDisplay: 'Somebody',
      userHash: '123456',
      userSkey: 'abcdef',
      version: '1.2.3',
    );

    expect(review.toJson(), equals(json));
    expect(OdrsReview.fromJson(json), equals(review));
  });
}
