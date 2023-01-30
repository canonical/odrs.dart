import 'dart:convert';
import 'dart:io';

import 'exception.dart';
import 'rating.dart';
import 'review.dart';

class OdrsClient {
  OdrsClient({
    required Uri url,
    required String userHash,
    required String distro,
    HttpClient? client,
  })  : _client = client ?? _createClient(url),
        _url = url,
        _userHash = userHash,
        _distro = distro;

  final HttpClient _client;
  final Uri _url;
  final String _userHash;
  final String _distro;

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

  Future<List<OdrsReview>> getReviews(String appId, {String? userHash}) {
    return _request<List>(
      'GET',
      '1.0/reviews/api/app/$appId',
      queryParameters: userHash != null ? {'user_hash': userHash} : null,
    )
        .then((value) =>
            value!.map((v) => OdrsReview.fromJson(v.cast<String, dynamic>())))
        .then((value) => value.toList());
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
  }) async {
    final json = {
      'user_hash': _userHash,
      'app_id': appId,
      'locale': locale ?? Platform.localeName,
      'distro': _distro,
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
      _url.resolve(path).replace(queryParameters: queryParameters),
    );
    for (final header in headers.entries) {
      request.headers.add(header.key, header.value);
    }
    if (body != null) request.write(json.encode(body));
    return _response<T>(await request.close());
  }

  Future<T?> _response<T>(HttpClientResponse response) async {
    final json = jsonDecode(await response.transform(utf8.decoder).join());
    if (json is Map && json['success'] == false) {
      throw OdrsException(json['msg'] as String);
    }
    return json is T ? json : null;
  }
}
