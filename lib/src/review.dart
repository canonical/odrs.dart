import 'package:meta/meta.dart';

@immutable
class OdrsReview {
  const OdrsReview({
    required this.appId,
    required this.dateCreated,
    this.description,
    this.distro,
    this.karmaDown = 0,
    this.karmaUp = 0,
    this.locale,
    this.rating = 0,
    this.reported = 0,
    required this.reviewId,
    this.summary,
    this.userDisplay,
    this.userHash,
    this.userSkey,
    this.version,
  });

  final String appId;
  final DateTime dateCreated;
  final String? description;
  final String? distro;
  final int karmaDown;
  final int karmaUp;
  final String? locale;
  final int rating;
  final int reported;
  final int reviewId;
  final String? summary;
  final String? userDisplay;
  final String? userHash;
  final String? userSkey;
  final String? version;

  factory OdrsReview.fromJson(Map<String, dynamic> json) {
    return OdrsReview(
      appId: json['app_id'] as String,
      dateCreated: DateTime.fromMillisecondsSinceEpoch(
        ((json['date_created'] as double? ?? 0) * 1000.0).round(),
      ),
      description: json['description'] as String?,
      distro: json['distro'] as String?,
      karmaDown: json['karma_down'] as int? ?? 0,
      karmaUp: json['karma_up'] as int? ?? 0,
      locale: json['locale'] as String?,
      rating: json['rating'] as int? ?? 0,
      reported: json['reported'] as int? ?? 0,
      reviewId: json['review_id'] as int? ?? -1,
      summary: json['summary'] as String?,
      userDisplay: json['user_display'] as String?,
      userHash: json['user_hash'] as String?,
      userSkey: json['user_skey'] as String?,
      version: json['version'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_id': appId,
      'date_created': dateCreated.millisecondsSinceEpoch / 1000.0,
      'description': description,
      'distro': distro,
      'karma_down': karmaDown,
      'karma_up': karmaUp,
      'locale': locale,
      'rating': rating,
      'reported': reported,
      'review_id': reviewId,
      'summary': summary,
      'user_display': userDisplay,
      'user_hash': userHash,
      'user_skey': userSkey,
      'version': version,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OdrsReview &&
        other.appId == appId &&
        other.dateCreated == dateCreated &&
        other.description == description &&
        other.distro == distro &&
        other.karmaDown == karmaDown &&
        other.karmaUp == karmaUp &&
        other.locale == locale &&
        other.rating == rating &&
        other.reported == reported &&
        other.reviewId == reviewId &&
        other.summary == summary &&
        other.userDisplay == userDisplay &&
        other.userHash == userHash &&
        other.userSkey == userSkey &&
        other.version == version;
  }

  @override
  int get hashCode {
    return Object.hash(
      appId,
      dateCreated,
      description,
      distro,
      karmaDown,
      karmaUp,
      locale,
      rating,
      reported,
      reviewId,
      summary,
      userDisplay,
      userHash,
      userSkey,
      version,
    );
  }

  @override
  String toString() {
    return 'OdrsReview(appId: $appId, dateCreated: $dateCreated, description: $description, distro: $distro, karmaDown: $karmaDown, karmaUp: $karmaUp, locale: $locale, rating: $rating, reported: $reported, reviewId: $reviewId, summary: $summary, userDisplay: $userDisplay, userHash: $userHash, userSkey: $userSkey, version: $version)';
  }
}
