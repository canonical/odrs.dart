import 'dart:convert';
import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:odrs/odrs.dart';
import 'package:test/test.dart';

import 'odrs_client_test.mocks.dart';

@GenerateMocks([HttpClient, HttpClientRequest, HttpClientResponse, HttpHeaders])
void main() {
  final localhost = Uri.https('localhost:8080');

  test('get ratings', () async {
    final http = MockHttpClient();
    final url = localhost.resolve('/1.0/reviews/api/ratings');
    final request = mockRequest({
      'foo': {
        'star0': 1,
        'star1': 2,
        'star2': 3,
        'star3': 4,
        'star4': 5,
        'star5': 6,
        'total': 21,
      },
      'bar': {
        'star0': 11,
        'star1': 22,
        'star2': 33,
        'star3': 44,
        'star4': 55,
        'star5': 66,
        'total': 231,
      },
    });
    when(http.openUrl('GET', url)).thenAnswer((_) async => request);

    final client = OdrsClient(
      url: localhost,
      client: http,
      userHash: '',
      distro: '',
    );
    final ratings = await client.getRatings();
    verify(http.openUrl('GET', url)).called(1);
    verify(request.close()).called(1);

    expect(
      ratings,
      equals({
        'foo': OdrsRating(
          star0: 1,
          star1: 2,
          star2: 3,
          star3: 4,
          star4: 5,
          star5: 6,
          total: 21,
        ),
        'bar': OdrsRating(
          star0: 11,
          star1: 22,
          star2: 33,
          star3: 44,
          star4: 55,
          star5: 66,
          total: 231,
        ),
      }),
    );
  });

  test('get rating', () async {
    final http = MockHttpClient();
    final url = localhost.resolve('/1.0/reviews/api/ratings/foo');
    final request = mockRequest({
      'star0': 1,
      'star1': 2,
      'star2': 3,
      'star3': 4,
      'star4': 5,
      'star5': 6,
      'total': 21,
    });
    when(http.openUrl('GET', url)).thenAnswer((_) async => request);

    final client = OdrsClient(
      url: localhost,
      client: http,
      userHash: '',
      distro: '',
    );
    final rating = await client.getRating('foo');
    verify(http.openUrl('GET', url)).called(1);
    verify(request.close()).called(1);

    expect(
      rating,
      equals(
        OdrsRating(
          star0: 1,
          star1: 2,
          star2: 3,
          star3: 4,
          star4: 5,
          star5: 6,
          total: 21,
        ),
      ),
    );
  });

  test('submit review', () async {
    final http = MockHttpClient();
    final url = localhost.resolve('/1.0/reviews/api/submit');
    final request = mockRequest({'success': true});
    when(http.openUrl('POST', url)).thenAnswer((_) async => request);

    final client = OdrsClient(
      url: localhost,
      client: http,
      userHash: '123456',
      distro: 'Ubuntu',
    );
    await client.submitReview(
      appId: 'foo',
      rating: 100,
      locale: 'en_US.UTF-8',
      version: '0',
      userDisplay: 'Somebody',
      summary: 'Summary...',
      description: 'Description...',
    );
    verify(http.openUrl('POST', url)).called(1);
    verify(request.write(jsonEncode({
      'user_hash': '123456',
      'app_id': 'foo',
      'locale': 'en_US.UTF-8',
      'distro': 'Ubuntu',
      'version': '0',
      'user_display': 'Somebody',
      'summary': 'Summary...',
      'description': 'Description...',
      'rating': 100,
    })));
    verify(request.close()).called(1);
  });

  test('failure', () async {
    final http = MockHttpClient();
    final url = localhost.resolve('/1.0/reviews/api/ratings/foo');
    final request = mockRequest({
      'success': false,
      'msg': 'Something went wrong',
    });
    when(http.openUrl('GET', url)).thenAnswer((_) async => request);

    final client = OdrsClient(
      url: localhost,
      client: http,
      userHash: '',
      distro: '',
    );
    expect(
        () => client.getRating('foo'),
        throwsA(isA<OdrsException>().having(
            (e) => e.toString(), 'message', 'ODRS: Something went wrong')));
  });

  test('user agent', () {
    final http = MockHttpClient();
    final client = OdrsClient(
      url: localhost,
      userHash: '',
      distro: '',
      client: http,
    );
    client.userAgent = 'foo';
    verify(http.userAgent = 'foo').called(1);
  });

  test('close client', () {
    final http = MockHttpClient();
    final client = OdrsClient(
      url: localhost,
      userHash: '',
      distro: '',
      client: http,
    );
    client.close();
    verify(http.close()).called(1);
  });
}

MockHttpClientRequest mockRequest(dynamic data, {int statusCode = 200}) {
  final response = MockHttpClientResponse();
  when(response.statusCode).thenReturn(statusCode);
  when(response.transform(utf8.decoder))
      .thenAnswer((_) => Stream.value(jsonEncode(data)));

  final headers = MockHttpHeaders();
  when(headers.contentType).thenReturn(ContentType('application', 'json'));
  when(headers.contentLength).thenReturn(data.length);

  final request = MockHttpClientRequest();
  when(request.headers).thenReturn(headers);
  when(request.done).thenAnswer((_) async => response);
  when(request.close()).thenAnswer((_) async => response);
  return request;
}
