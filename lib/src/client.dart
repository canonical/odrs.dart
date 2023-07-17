import 'dart:convert';
import 'dart:io';

import 'exception.dart';
import 'rating.dart';
import 'review.dart';

class OdrsClient {
  OdrsClient({
    required this.url,
    required this.userHash,
    required this.distro,
    HttpClient? client,
  }) : _client = client ?? _createClient(url);

  final HttpClient _client;

  final Uri url;
  final String userHash;
  final String distro;

  static HttpClient _createClient(Uri url) {
    final client = HttpClient();
    client.userAgent = 'odrs.dart';
    return client;
  }

  set userAgent(String? value) => _client.userAgent = value;

  void close() => _client.close();

  /// Get the star ratings for all known applications.
  Future<Map<String, OdrsRating>> getRatings() {
    return _request<Map>('GET', '1.0/reviews/api/ratings').then(
        (value) => value!.map((k, v) => MapEntry(k, OdrsRating.fromJson(v))));
  }

  /// Get the star ratings for a specific application.
  // NOTE: https://odrs-dev.apps.openshift4.gnome.org works, https://odrs.gnome.org not
  Future<OdrsRating?> getRating(String appId) {
    return _request<Map>('GET', '1.0/reviews/api/ratings/$appId').then(
        (value) => value != null
            ? OdrsRating.fromJson(value.cast<String, dynamic>())
            : null);
  }

  /// Return details about an application.
  Future<List<OdrsReview>> getReviews({
    required String appId,
    List<String>? compatIds,
    String? locale,
    int limit = 0,
    int start = 0,
    String? version,
  }) {
    final json = {
      'user_hash': userHash,
      'app_id': appId,
      if (compatIds != null) 'compat_ids': compatIds,
      'locale': locale ?? Platform.localeName,
      'distro': distro,
      'limit': limit,
      'start': start,
      'version': version ?? 0,
    };
    return _request<List>('POST', '1.0/reviews/api/fetch', body: json)
        .then((value) =>
            value!.map((v) => OdrsReview.fromJson(v.cast<String, dynamic>())))
        .then((value) => value.toList());
  }

  /// Upvote an existing review by one karma point.
  Future<void> upvoteReview(OdrsReview review) {
    return _voteReview(review, 'upvote');
  }

  /// Downvote an existing review by one karma point.
  Future<void> downvoteReview(OdrsReview review) {
    return _voteReview(review, 'downvote');
  }

  /// Dismiss a review without rating it up or down.
  Future<void> dismissReview(OdrsReview review) {
    return _voteReview(review, 'dismiss');
  }

  /// Report a review for abuse.
  Future<void> reportReview(OdrsReview review) {
    return _voteReview(review, 'report');
  }

  Future<void> _voteReview(OdrsReview review, String vote) {
    final json = {
      'app_id': review.appId,
      'review_id': review.reviewId,
      'user_hash': userHash,
      'user_skey': review.userSkey,
    };
    return _request('POST', '1.0/reviews/api/$vote', body: json);
  }

  /// Submit a review for an application.
  Future<void> submitReview({
    required String appId,
    required int rating,
    String? locale,
    required String version,
    required String userDisplay,
    required String summary,
    required String description,
  }) {
    final json = {
      'user_hash': userHash,
      'app_id': appId,
      'locale': locale ?? Platform.localeName,
      'distro': distro,
      'version': version,
      'user_display': userDisplay,
      'summary': summary,
      'description': description,
      'rating': rating,
    };
    return _request('POST', '1.0/reviews/api/submit', body: json);
  }

  Future<T?> _request<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, Object> headers = const {},
    dynamic body,
  }) async {
    final request = await _client.openUrl(
      method,
      url.resolve(path).replace(queryParameters: queryParameters),
    );
    request.headers.contentType = ContentType.json;
    for (final header in headers.entries) {
      request.headers.add(header.key, header.value);
    }
    if (body != null) request.write(json.encode(body));
    return _response<T>(await request.close());
  }

  Future<T?> _response<T>(HttpClientResponse response) async {
    final data = await response.transform(utf8.decoder).join();
    try {
      final json = jsonDecode(data);
      if (json is Map && json['success'] == false) {
        throw OdrsException(json['msg'] as String);
      }
      return json is T ? json : null;
    } on FormatException catch (e) {
      // TODO: https://github.com/canonical/odrs.dart/issues/1
      // print(data);
      throw OdrsException(e.message);
    }
  }
}
